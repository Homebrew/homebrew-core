class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "808175cfb4a45f10fa0a23f04de6a51b3d27f8c1c282a19e98b91c80c5eeebfb"
  license "LGPL-3.0-only"
  head "https://github.com/c3lang/c3c.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26101c50c6964de8834fbc1f128ad1919ad3cc8b8cade1a88b5b57ef53dab7f9"
    sha256 cellar: :any,                 arm64_sequoia: "8d726c291078460dabe0afc8b0434139ad52b0ad8639fd7d4116a5a298ff2c5c"
    sha256 cellar: :any,                 arm64_sonoma:  "e8b2006d6d751787d1b451671d8905eac93984a24915523896a5c89d2d425b89"
    sha256 cellar: :any,                 sonoma:        "202a6d51b538ab12b1f429006ec0017d6e5c1a87b4d1be9f6dfc3d62461dd33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eafea707789ab0d63bfc268e0f6ee2990ccdb1be0c0ab5fe8610cb00f36b42a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aac1fac9bd211b62ea18898bc68fa92ca34b0a0157978732ef314957aed537ca"
  end

  depends_on "cmake" => :build
  depends_on "lld"
  depends_on "llvm"

  uses_from_macos "curl"

  def install
    lld = Formula["lld"]
    llvm = Formula["llvm"]

    args = [
      "-DC3_LINK_DYNAMIC=ON",
      "-DC3_USE_MIMALLOC=OFF",
      "-DC3_USE_TB=OFF",
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
      "-DLLVM=#{llvm.opt_lib/shared_library("libLLVM")}",
      "-DLLD_COFF=#{lld.opt_lib/shared_library("liblldCOFF")}",
      "-DLLD_COMMON=#{lld.opt_lib/shared_library("liblldCommon")}",
      "-DLLD_ELF=#{lld.opt_lib/shared_library("liblldELF")}",
      "-DLLD_MACHO=#{lld.opt_lib/shared_library("liblldMachO")}",
      "-DLLD_MINGW=#{lld.opt_lib/shared_library("liblldMinGW")}",
      "-DLLD_WASM=#{lld.opt_lib/shared_library("liblldWasm")}",
    ]
    args << "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # The build copies LLVM runtime libraries into its `bin` directory.
    # Let's replace those copies with a symlink instead.
    libexec.install bin.children
    bin.install_symlink libexec.children.select { |child| child.file? && child.executable? }
    rm_r libexec/"c3c_rt"
    libexec.install_symlink llvm.opt_lib/"clang"/llvm.version.major/"lib/darwin" => "c3c_rt"
  end

  test do
    (testpath/"test.c3").write <<~EOS
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    EOS
    system bin/"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}/test")
  end
end

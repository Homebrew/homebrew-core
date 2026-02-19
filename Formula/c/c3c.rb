class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "d9867c80e9dea5a96badd7c88937e155ead31f3dc6aa0758010ce0734877d17b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "bb9c2b45c04628b7c78e977610af4e6dea6809dbdeaee4ae7cb269f8967ab580"
    sha256 cellar: :any,                 arm64_sequoia: "2accf9471d9628de0b288aec01d2b98b1fd7bd620d29ad0725432a1af450e71e"
    sha256 cellar: :any,                 arm64_sonoma:  "884941b1705c4a6239276d1b9e2c835636a42a4c742bb5690bded30fb9d05422"
    sha256 cellar: :any,                 sonoma:        "74668d3f7a88a779a36469fc77d2f7f85deeb910bbb217ff7588ee5c83c879b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63e9cecbe430a0ea1bff4f085e98a3df3a2ea9da5d0b9881f005857308ebfcdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06be78cae0c8f890d2af424b39e92f3192fb183da32c182570fef11d7fe9edb7"
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

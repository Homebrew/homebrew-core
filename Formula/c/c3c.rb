class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://c3-lang.org"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "ce2bd6e7658b480278e3a3af7c999b7a55d8a042c26446e9ea317f9357a8416b"
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
    sha256 cellar: :any, arm64_golden_gate: "8bece8a87917947f3821815e7ff002dce4f34fbdfe4ebb73ee69cb2c9d4827b0"
    sha256 cellar: :any, arm64_tahoe:       "38f77fd82605e4fb6eb596ccf393f251191307b476272e0904d76dfeda6eadfe"
    sha256 cellar: :any, arm64_sequoia:     "b9a906948e6036e5c51a13c7a48a9a9eb163b83bb0b57858c73129d6f0d7cd35"
    sha256 cellar: :any, arm64_linux:       "4c84fcbd0f8a1f9bab6862165d0ba4884a14a027a19fc8bbf17d6056e1874c5b"
    sha256 cellar: :any, x86_64_linux:      "502ac9ae489105aae5f3a0b4c3ae4956ae4ac3851acda10b0add9d1a52d656cf"
  end

  depends_on "cmake" => :build
  depends_on "lld"
  depends_on "llvm"

  uses_from_macos "curl"

  deny_network_access!

  def install
    lld = Formula["lld"]
    llvm = Formula["llvm"]

    args = [
      "-DC3_LINK_DYNAMIC=ON",
      "-DC3_USE_MIMALLOC=OFF",
      "-DC3_USE_TB=OFF",
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
      "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm",
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
    (testpath/"test.c3").write <<~C3
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    C3
    system bin/"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}/test")
  end
end

class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://c3-lang.org"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "d689bbb43d9b392a994420ff801b6b58fe21d6c329a6a36f73c5f57711486ffb"
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
    sha256 cellar: :any, arm64_golden_gate: "ecf32c1fae03075040b773b0b0184314c5690f73dfdce309db0c7690029f951f"
    sha256 cellar: :any, arm64_tahoe:       "474a0d657aba7c5c88654c6807a3be95524076a84e0ebf2be452a0ebcf49da68"
    sha256 cellar: :any, arm64_sequoia:     "731a13f2c7bafef8d70395def9862381d18dd05ebb39f15b001d2dd0df9e13d7"
    sha256 cellar: :any, arm64_sonoma:      "d16ff42855af1bcb5ef5a7e26a09f1f51d5f375de75c7cbe890403380a9f45ad"
    sha256 cellar: :any, sonoma:            "84180833c7589f48763356bffee04ac740f5d89cf78aea0ed715b029fac40bcb"
    sha256 cellar: :any, arm64_linux:       "9b6b1ccb4d8c6ea3c7737fc9cf4e9120252a44ec6ba6494b8781c1b7cf996b7f"
    sha256 cellar: :any, x86_64_linux:      "ff754382d7660d33b25ba40c95667aa7cb187c8a78e54fae81411fe6590201cf"
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

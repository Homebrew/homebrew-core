class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "bb18f76afdd13b3696c8acf53465eb0e1fc175ec6323cf9a3e61dc6634ad3ca0"
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
    sha256 cellar: :any, arm64_sequoia: "b50a1d354a416ac73ab60c0c0295d93172c567dbbecb8a042e489a4124ac6233"
    sha256 cellar: :any, arm64_sonoma:  "882a8f0bf00107ce4851a2da6feadc26e29f6d0c25c942aff3f2df0ca67f3b36"
    sha256 cellar: :any, arm64_ventura: "3882662dfda73d09456a78627736015d2c6b515831cbea8834b2c5b07f6d4581"
    sha256 cellar: :any, sonoma:        "c0ac025e9145794d3b05bdfd1ff89a98e83775d4a4e338ebc873060a08a9647b"
    sha256 cellar: :any, ventura:       "4628e5f125da94851cdc8362df8532c4a33b0113b74d75df9503c1cec06782fb"
    sha256               arm64_linux:   "d260271c0e5b7037e94aed1a3bcafbe0aecbaf8139f9a6b0e0b726c450dd2fdd"
    sha256               x86_64_linux:  "30d98cbbe0e8e66ca6cb619934feca8a915bdf780bcfcd839bf4d242a7e1f4ec"
  end

  depends_on "cmake" => :build
  depends_on "lld"
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # Linking dynamically with LLVM fails with GCC.
  fails_with :gcc

  def install
    args = [
      "-DC3_LINK_DYNAMIC=ON",
      "-DC3_USE_MIMALLOC=OFF",
      "-DC3_USE_TB=OFF",
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
      "-DLLVM=#{Formula["llvm"].opt_lib/shared_library("libLLVM")}",
      "-DLLD_COFF=#{Formula["lld"].opt_lib/shared_library("liblldCOFF")}",
      "-DLLD_COMMON=#{Formula["lld"].opt_lib/shared_library("liblldCommon")}",
      "-DLLD_ELF=#{Formula["lld"].opt_lib/shared_library("liblldELF")}",
      "-DLLD_MACHO=#{Formula["lld"].opt_lib/shared_library("liblldMachO")}",
      "-DLLD_MINGW=#{Formula["lld"].opt_lib/shared_library("liblldMinGW")}",
      "-DLLD_WASM=#{Formula["lld"].opt_lib/shared_library("liblldWasm")}",
    ]

    ENV.append "LDFLAGS", "-lzstd -lz"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # The build copies LLVM runtime libraries into its `bin` directory.
    # Let's replace those copies with a symlink instead.
    libexec.install bin.children
    bin.install_symlink libexec.children.select { |child| child.file? && child.executable? }
    rm_r libexec/"c3c_rt"
    llvm = Formula["llvm"]
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

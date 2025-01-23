class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "e09ebe8485fef6a7ae5cd7a86e506f83d2f2c39a944756afa6774d5f666bdb72"
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
    sha256 cellar: :any, arm64_sequoia: "7df5dde0fba020aef50e4c4935bdc48bb17e44d909f0233637e6f5314b3534e4"
    sha256 cellar: :any, arm64_sonoma:  "524ad164f3787097b25de83dd3e61b3d28c43e454196fddf802da800803a75ef"
    sha256 cellar: :any, arm64_ventura: "1dbf7aeee8a86f99c579eb799faf94145f39515cd078b9805a88fd0771c41370"
    sha256 cellar: :any, sonoma:        "12d42248ea6c157525fc29c6ede534d7e80f1f18905c927f62859ee049f8c6ff"
    sha256 cellar: :any, ventura:       "3c06c8476c85ae2fea6051b145017cc76112e153a0b7901363832e60ca55e8f1"
    sha256               x86_64_linux:  "e3fea1341d4f757ba6eb3ef9b6d87671f48f554907ac9f70de9717faa8ac43ea"
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

class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "dc0e507ad4f11df2535e19f73d657c2337f72e017344504429919be3f29bcb71"
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
    sha256 cellar: :any, arm64_sequoia: "b4979cd4cff8e1ff1d90a8ced045063aacb10b95bc4b08008e6d093c37e6d454"
    sha256 cellar: :any, arm64_sonoma:  "e133eefe54ba5b5e6c824a557232f36045db1d9ba962bc95b7f16835e6ac5158"
    sha256 cellar: :any, arm64_ventura: "a24c77072e80c0c58168685d2454487f6b5006b993270b9cb703198fea8bf19d"
    sha256 cellar: :any, sonoma:        "efb961142f818e43d5b025b2b7e2b2878cc56396289dfec2269a3cc7bb3e4088"
    sha256 cellar: :any, ventura:       "466b6ec7e5701dcd7559d87f6cdbe83098866894e257a3d76d4160be60a0b241"
    sha256               arm64_linux:   "e65075becd83ff9b4a83b5fb2661dbf2e39716daa77a94263a8fb530ad01470a"
    sha256               x86_64_linux:  "24bb1fd3a6499c7bf288be9c0b5f0b75d3968b9becf09bd584c5e026ec06d3dd"
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

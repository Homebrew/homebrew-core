class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_113.tar.gz"
  sha256 "d2c32e85587ae95001a78a8765e12556be0fa8965e2f1fa6fc622aa2e0c4a33d"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "854add124ffb6d28b70851b8c12028e140c9012e09650cf9dd80e90dd12d8e99"
    sha256 cellar: :any,                 arm64_monterey: "dc1975ddace5e5bcad79f4793cea97e10d5ed53ebf0a841397734ef21a6d7972"
    sha256 cellar: :any,                 arm64_big_sur:  "6452d3522faa7c071b2fccf703044e0f3f3c6bcc0156d779acbc8b960a000717"
    sha256 cellar: :any,                 ventura:        "7af0289b729abf02102a6db8081234c70aff5983ebd33e80eba530e83643c9f0"
    sha256 cellar: :any,                 monterey:       "ed64960281066f638bcd6a21becf0baadc0469d92935c35af2be590df0eb8ad5"
    sha256 cellar: :any,                 big_sur:        "f1200300b3a504294900b66d66c40037cb8dc758cb1785704b15208be3b24f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c33f188012eec89c5b875c10171b3353174bc0703ca6ffc153d267e22a3372"
  end

  depends_on "cmake" => :build
  depends_on macos: :mojave # needs std::variant

  fails_with :gcc do
    version "6"
    cause "needs std::variant"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTS=false"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test/"
  end

  test do
    system bin/"wasm-opt", "-O", pkgshare/"test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", (testpath/"1.wast").read
  end
end

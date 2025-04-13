class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_123.tar.gz"
  sha256 "a1e1caf250cab3a83938713594e55b6762591208e82087e3337f793e8c8eb7ab"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-](\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cae7c7240852ade709aa96ba6be8277dcd252c342d1f75413f5de61a7fe5b7ec"
    sha256 cellar: :any,                 arm64_sonoma:  "1a5b35f988f3f9695a6aca0186da2bdd74a59a4ff6b87bcaaf0930a8899ba6bf"
    sha256 cellar: :any,                 arm64_ventura: "e788038e064c5b7eaf470c7a5af2508d937c8aa31cb97139f8fcb27356cc0fc6"
    sha256 cellar: :any,                 sonoma:        "4395563fd2278982a88fa7e943c0aeab191e7f6fc4376fe1813d59ec30b3c071"
    sha256 cellar: :any,                 ventura:       "d7156e63442c27fd4f6c990b1bfb4588d6e8dff4cd95a3860ea1e784eccc2fd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ed954b4d562431745bf2b1afaa96d2a4f655718c83b71ad1af3021ff83fceaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8511e6e135f18fa2cc5920273fa964c05a8e80d305b1f5f61e97c04f4691d6a1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTS=false", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test/"
  end

  test do
    system bin/"wasm-opt", "-O", pkgshare/"test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", (testpath/"1.wast").read
  end
end

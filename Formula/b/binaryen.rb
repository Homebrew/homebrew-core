class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_118.tar.gz"
  sha256 "58a2fbad5aa986b52f8044c99fa7780e0a524e3d1bcc4f588ccda62bc33498a7"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d830972b691fcbeee7ff7cefa704ad252c047f0c70b96b8f209b6fd798c8335b"
    sha256 cellar: :any,                 arm64_ventura:  "02be9783ad59dcf431c96dc04e5e278bfa603530751366208eba57c48d581591"
    sha256 cellar: :any,                 arm64_monterey: "38c45fe90f26ee0c9fef4d7d59b5753c33108d8f777f4aff400bcc8d512b02e2"
    sha256 cellar: :any,                 sonoma:         "d69dd35df278a2901814dc401de689e3016003ad6bacaf30df4e0f7de3340aef"
    sha256 cellar: :any,                 ventura:        "439ce7950daecef27a7716c77f63133334337160f507f2afc8502110b795d4cd"
    sha256 cellar: :any,                 monterey:       "94602460d789580b5d932cd8190bee0f5eff90c68b09d91599a6f41920f392f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d3b74a1000f4627eae869a0a98a29772cc8e3ed10e99fa49dd735ec31d512fa"
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

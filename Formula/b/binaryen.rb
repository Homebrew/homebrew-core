class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_119.tar.gz"
  sha256 "9c2614212f628fad451b847ffa0ce2fc59339453f4ea1bacf4417590caa5fc71"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b25e6cac71cdd5bbda087ca5f26a9cb74aa6904aafd99b5aa89d6cf7532f6af1"
    sha256 cellar: :any,                 arm64_sonoma:   "e5893a0101f802e12b0decb4be1732d28e61eb5fd19c742ad75d989f25b3957a"
    sha256 cellar: :any,                 arm64_ventura:  "f48ecdbb0418e148de8b3403c2fda3be3b750c5607ab9ac73d7aeb223778b58a"
    sha256 cellar: :any,                 arm64_monterey: "14adce32c4d922526f3991e50cadc760b1e8018cda3d3c64fa76599a579efbbe"
    sha256 cellar: :any,                 sonoma:         "0c3f78337a1f52115aae5b7e8f80a5e88db8fc54bfc3d090073079714ea51195"
    sha256 cellar: :any,                 ventura:        "c8f2b792e00ec7ff7e6db6de94ae4e68a0606ddabab325227a81d565a2606bad"
    sha256 cellar: :any,                 monterey:       "7c7b9ae4cef5fffa4a3aa95fd07a4d3e03a3b112c26233d26a4753dfeab91148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01fafa6fa858845b8019e35b5352d93fe1a36964587b013d50c57755f06c8186"
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

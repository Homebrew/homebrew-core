class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_111.tar.gz"
  sha256 "c518b1146713bc2406dd09a1a1b18f31a283f8ac1fe200efa38834dbd95a1997"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "45807d07e3d16808a911aa0f944c9c8c7a9b0e53990e84f9e37891ea3683b975"
    sha256 cellar: :any,                 arm64_monterey: "4208e154c9082621e5062866398cdb0ef47eb53bcc73baf224fc48abdbf998d1"
    sha256 cellar: :any,                 arm64_big_sur:  "278f526822dd520d16ada1755cee0b99720b92f8f954c54d20c208f0153e88d4"
    sha256 cellar: :any,                 ventura:        "16d90b3aa9fa901835def9892268d4ed827a581a777740de4c78c899d95f47db"
    sha256 cellar: :any,                 monterey:       "ef5bfee117bf529d6b2825387f426074cf0e1a17b89eb5d80ca57c59a63d0ba8"
    sha256 cellar: :any,                 big_sur:        "01c7c7bbb9508cf73236b073b92b750f88bd3f3d8fc0367e7bdbb30f6d220550"
    sha256 cellar: :any,                 catalina:       "3611d115f0bc997f55770c33eb7228aa439ff0b0ddf87c1fcd43c1b63deb4eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3366313678d1e80d85c0e7d1420a2145ee00df01e5162c11d3e989eec363e341"
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

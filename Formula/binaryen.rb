class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_110.tar.gz"
  sha256 "0f80250a02b94dd81bdedeae029eb805abf607fcdadcfee5ca8b5e6b77035601"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4c4d9c48b73fdc36e655be7ec999c85b8fea6e82e178ad0039ec1b092ae96d73"
    sha256 cellar: :any,                 arm64_big_sur:  "f78a4bd5a8ca59532c29837c9cba5748348bd5a757cac10420a8a29712db4ba1"
    sha256 cellar: :any,                 monterey:       "a99c28767c8d450e0ff4bd505f59276c1054aa83550229f381cb6d66f511a1b8"
    sha256 cellar: :any,                 big_sur:        "7e78efad3c1c4e6f55d8f0231abd8680d01e732ae0226a88deb14c1a44ee4760"
    sha256 cellar: :any,                 catalina:       "5c5a150f985a7c08bccac10ccd19ff79d561560012b85ab1c14fccbda4b9b4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cadc0af9d6df56f587b144243e847a76fcf7afbf068c2f7cc9b11b27537e1a9"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_TESTS=false"
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "-O", "#{pkgshare}/test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", File.read("1.wast")
  end
end

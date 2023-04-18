class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_112.tar.gz"
  sha256 "815cb5be322d97829b38ba246c1a657c227e9eea6bfab74cdf0e542c9e5220f8"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bc2b67e805f3960e17c81f905b4dc583a03769df3f3a2e35ed9b2858b01dfef2"
    sha256 cellar: :any,                 arm64_monterey: "52b5a15d0c928dac1c50bdddcb23be6b2956184f2d7e9c14839fe42c43b8415e"
    sha256 cellar: :any,                 arm64_big_sur:  "fa0e75cf42142b9402671bdadb3184531fdde86ebcd41c5a7c752b351600e1ff"
    sha256 cellar: :any,                 ventura:        "9a3bc903a8f75afc177fa9008d22af80c2eb724b4af87082f32c8112e3b613e2"
    sha256 cellar: :any,                 monterey:       "24d6e9389ca81fc08de91309263ab0184ff3a4d9ea56144d213f796ed6c7ac14"
    sha256 cellar: :any,                 big_sur:        "1a371c39592e64b7a40841bf5e89a42278ddcaa82e09b5844aeba136faed7a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9e5c2b57e0085be643c50fd567621fb49e4012476a93aecc6cebb8b0b33897d"
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

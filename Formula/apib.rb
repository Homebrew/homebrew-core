class Apib < Formula
  desc "HTTP performance-testing tool"
  homepage "https://github.com/apigee/apib"
  url "https://github.com/apigee/apib/archive/APIB_1_2_1.tar.gz"
  sha256 "e47f639aa6ffc14a2e5b03bf95e8b0edc390fa0bb2594a521f779d6e17afc14c"
  license "Apache-2.0"
  head "https://github.com/apigee/apib.git"

  bottle do
    cellar :any
    sha256 "24b8a6e851fe6e262765131c025e8dddada1c740ed7f3aa978d4fbc3bec939c1" => :big_sur
    sha256 "6c066e87db949d59e554c6c9b9e7657d249171dee7a2d3b7bc53b54f36daa762" => :arm64_big_sur
    sha256 "b925a48cd3a9047184b5373e4718e4142117a487467cea95be9f43f6c9951712" => :catalina
    sha256 "fd1f74b58c7a51240d463c8ec1203bce33677409aca81ba0ffba9ea718471433" => :mojave
    sha256 "aee416aff5715b96b81cfeda0be036a2510ffe760187e396c143a64bae2c25c2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "openssl@1.1"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "apib", "apibmon"

    bin.install "apib/apib", "apib/apibmon"
  end

  test do
    system "#{bin}/apib", "-c 1", "-d 1", "https://www.google.com"
  end
end

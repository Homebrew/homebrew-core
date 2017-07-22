class Log4cpp < Formula
  desc "Configurable logging for C++"
  homepage "https://log4cpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.3.tar.gz"
  sha256 "2cbbea55a5d6895c9f0116a9a9ce3afb86df383cd05c9d6c1a4238e5e5c8f51d"

  bottle do
    cellar :any
    sha256 "0ec821d25392727392d3d180a2c879f661ffdb93e03855fdba5aef323b78143d" => :sierra
    sha256 "8fcd11872030aea987ada00df36c30bfc8602e2a1607657a4c84b37a5672f17c" => :el_capitan
    sha256 "01471407b5381cc03e2911aae4876693295960ca9df12aa37d551890dc859fb0" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

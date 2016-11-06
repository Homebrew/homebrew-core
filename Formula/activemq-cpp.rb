class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/cms/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.9.3/activemq-cpp-library-3.9.3-src.tar.bz2"
  sha256 "d7554c6245f7a5f96e8b9751a562f841ee285777487ccfbca1bfd74db024b50e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6f9c2de75613e349422af1300c8d023603e501947d3631dc027654f3b09281ea" => :sierra
    sha256 "b54be46ced741f2722145bf28889c5837b44bdf0ca7161225935be18ae41cc67" => :el_capitan
    sha256 "bda92f40d2e5a608e5cb15c4330731202033e310f3cee686652ded0a56d21823" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "apr"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/activemqcpp-config", "--version"
  end
end

class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/components/cms/"
  url "https://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  mirror "https://archive.apache.org/dist/activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  sha256 "6bd794818ae5b5567dbdaeb30f0508cc7d03808a4b04e0d24695b2501ba70c15"
  revision 1

  bottle do
    cellar :any
    sha256 "c06d4253f9496b49b63c224637a97525b13ecb834884a3548adbdafe4dde0a73" => :catalina
    sha256 "024bf1c2c3ef8e612180b9f82c98f854235e8e371e01210c142304a762a30b3c" => :mojave
    sha256 "21855925e7e9ecfe125c959c84a6bce710ca409a2a33f4f8d396f45cc52a4ab9" => :high_sierra
    sha256 "c994de229e86fb7e80c846d6f2b44acba306014f334ba65550c15102214dbcb8" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "apr"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/activemqcpp-config", "--version"
  end
end

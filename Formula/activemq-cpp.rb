class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/cms/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  sha256 "6bd794818ae5b5567dbdaeb30f0508cc7d03808a4b04e0d24695b2501ba70c15"
  revision 1

  bottle do
    cellar :any
    sha256 "ca87456dfeee8d1b999d883a01db5a657996f31973cc2b516bfc2d704136028a" => :mojave
    sha256 "8bd27f343a7669f51d84068727be531fd65b98bc9567b161aaf025c1884a1809" => :high_sierra
    sha256 "9b4e5dcb89bb68292b695c8e056fad47a729b4a5e037c5ef4a95a7b1406c61e8" => :sierra
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

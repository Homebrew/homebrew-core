class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.13.0.tar.gz"
  sha256 "ed3d40058e0e36141bea7d7f0e39733a7b7409281cdf6a60be90186d412c2be1"
  revision 1

  bottle do
    cellar :any
    sha256 "dbc4d588ad5c5138761e4963fa0a99627a210964eb3f1e0f86c7b149b2779c59" => :high_sierra
    sha256 "943cef4709ff9edb647779d78c8b367d7a63cbe8f39584df93e615eaf535bda1" => :sierra
    sha256 "10c43f419c6fb77a011fd1e06f12a7c27458bd6f4cd2a49628f6870bc9ab38f7" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "yazpp"
  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  # Test by making metaproxy test a trivial configuration file (etc/config0.xml).
  test do
    (testpath/"test-config.xml").write <<~EOS
      <?xml version="1.0"?>
      <metaproxy xmlns="http://indexdata.com/metaproxy" version="1.0">
        <start route="start"/>
        <filters>
          <filter id="frontend" type="frontend_net">
            <port max_recv_bytes="1000000">@:9070</port>
            <message>FN</message>
            <stat-req>/fn_stat</stat-req>
          </filter>
        </filters>
        <routes>
          <route id="start">
            <filter refid="frontend"/>
            <filter type="log"><category access="false" line="true" apdu="true" /></filter>
            <filter type="backend_test"/>
            <filter type="bounce"/>
          </route>
        </routes>
      </metaproxy>
    EOS

    system "#{bin}/metaproxy", "-t", "--config", "#{testpath}/test-config.xml"
  end
end

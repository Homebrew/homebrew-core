class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.11.6.tar.gz"
  sha256 "33c9a9bcba3abb5592b3c1671455dc0d0a5747d2df014726abd0518e98a9cb76"

  bottle do
    cellar :any
    sha256 "2d6765d91c2bc9adf7cdef8ded32c9824748ab8c0f7837053f4ab226f7b506f5" => :sierra
    sha256 "16d1277e6a3dd404939288ab3f62130c120343a2d72fa2b2d759dd20cbb74652" => :el_capitan
    sha256 "838c1b6c0a1d3de4ae3e6d227552563d2b4a7d849d5c3a862e214dcd99bcc25f" => :yosemite
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
    (testpath/"test-config.xml").write <<-EOS.undent
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

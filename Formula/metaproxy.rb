class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.10.0.tar.gz"
  sha256 "83a282a9aefa71fd073adc2ef1c474e8b594c921da0c2c4b977821bfc3cf5a5e"
  revision 3

  bottle do
    cellar :any
    sha256 "dd6db923467cb12c80abea24c0e2e2c6a342ae65eb9c8b1f91c130ca90a2c308" => :sierra
    sha256 "2f56dc6dee4a787530df30d7e90e293e7762edd1e0716e88c3f9438ab746c536" => :el_capitan
    sha256 "c1bd04d4314082691ac797ad8472c20869e5e1cf4d7602323a0dd1955cba15d3" => :yosemite
    sha256 "bcfdee8fdf7cf28bde13366383b9e61327b48f25ab67fa06307f294c9526dec9" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "yazpp"
  depends_on "boost@1.61"

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

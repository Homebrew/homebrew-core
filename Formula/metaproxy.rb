class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.17.0.tar.gz"
  sha256 "3bdd0b31d9d6165b13dc76c95827ba7310e1f6cad68bf4dbf81b67f866f078fe"

  bottle do
    cellar :any
    sha256 "457f46ba4defa7420c038454364918f9534748c19cc580336f4cc92c18950408" => :mojave
    sha256 "a9c9e883e70f0dc8173d6f2c43218de0178024fa080f114495c136e7545db9a1" => :high_sierra
    sha256 "89c12962098cbc8fac874979f849f927b6dd8eca2df6f183062a37ba2501264f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yazpp"

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

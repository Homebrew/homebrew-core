class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.17.0.tar.gz"
  sha256 "3bdd0b31d9d6165b13dc76c95827ba7310e1f6cad68bf4dbf81b67f866f078fe"

  bottle do
    cellar :any
    sha256 "9c048d27fef8ee274b3de16e2b7592fb27a1688ddce933875ceb9189b2d48e1a" => :catalina
    sha256 "35224baef53f4e454bd19535184265c7e51c39ff76d8375cf4edd7baf4d50523" => :mojave
    sha256 "8054b8d37acdb51a7561ac1d1e5df25e22cbc60ceebdb791c401645165d2777c" => :high_sierra
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

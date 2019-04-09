class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.15.0.tar.gz"
  sha256 "b43a9e4dd2c231442ea07af7a05e929cd6cae2921826f66d201397b838aa8aac"
  revision 2

  bottle do
    cellar :any
    sha256 "2c6517c647813df8178c0b84eb83dca7234ca8cf43276d37f3caacdef330a502" => :mojave
    sha256 "f8aa17e2d7ca539ac9e490704bb3327a11f4de5b0909fcdf9bd6fb7afe5eae8a" => :high_sierra
    sha256 "11ec2478eae4aa5a1da4a7f3cb720324ba1455402394f9a902d02ba652e88ac1" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yazpp"

  # fix build for boost 1.69
  patch do
    url "https://github.com/indexdata/metaproxy/commit/186513e6205c6b0216e727907aa9e8d7b162f070.patch?full_index=1"
    sha256 "69579e45d27de8243f7ea3d7d3d23ef954ba7949995f08c07f7f88e81601fb39"
  end

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

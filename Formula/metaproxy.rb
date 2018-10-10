class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.15.0.tar.gz"
  sha256 "b43a9e4dd2c231442ea07af7a05e929cd6cae2921826f66d201397b838aa8aac"

  bottle do
    cellar :any
    sha256 "2bf435f20191dfb5cf8ccad286fb8bc103da913e7705028903db64825f5e7503" => :mojave
    sha256 "4bbc662e593c36b46746f1b27a2528dfcd960787201d6a994510a60ea9a714f9" => :high_sierra
    sha256 "19a4be3cef858418fa57d8362c81e9aa142bb471b43525c86d81f197c48cb15d" => :sierra
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

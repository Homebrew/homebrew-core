class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.10.0.tar.gz"
  sha256 "83a282a9aefa71fd073adc2ef1c474e8b594c921da0c2c4b977821bfc3cf5a5e"
  revision 3

  bottle do
    cellar :any
    sha256 "2c06851b2c9102e3bf317fbc8a2582f8891f8ceb1a0ef3e5b58fc1d7167cdbf5" => :sierra
    sha256 "0e087c89cf8b1420762aa9a4c53e39ac5c5897b7b561549aef9af40d46fd6ab3" => :el_capitan
    sha256 "7878ca3619bdbc455bb7b4c9f53d2160eb95a76fef2a64a13811fcbac205a838" => :yosemite
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

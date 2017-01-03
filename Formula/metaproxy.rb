class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.11.8.tar.gz"
  sha256 "9060db1fca1187077f7c9e274e6118add5770a4cbd849286a755b49e4be59d68"

  bottle do
    cellar :any
    sha256 "325b72f3a34f75011b6116a7759d7d810c942439f2a34417854f4129339ec5e5" => :sierra
    sha256 "85a3118660e51393f7d6ff223838b645fc55587d282fbf2c1bd973950f662a6d" => :el_capitan
    sha256 "ca12d07a9094883252da8734fff7679fdcb541c2440b7777efe335674b01c7ef" => :yosemite
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

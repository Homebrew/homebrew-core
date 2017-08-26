class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.12.1.tar.gz"
  sha256 "65b2138381a6a2d5a10f789b45f3472ceed2bf2cdfa35e88adfb262fd058fb48"

  bottle do
    cellar :any
    sha256 "f76a3b0f082335710577d29d963fb05550827c9b8f515be250b3a0a8e0a11d15" => :sierra
    sha256 "9b4c8431266ed8ebea3499b4188df1d399d27ba6deeb19ac9aedfdb0c518c7db" => :el_capitan
    sha256 "da9483dc3b4e89f0f543c7e54afe30cc1df2eb683273cf3d739d048aa51c50d4" => :yosemite
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

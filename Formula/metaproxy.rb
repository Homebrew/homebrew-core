class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.13.0.tar.gz"
  sha256 "ed3d40058e0e36141bea7d7f0e39733a7b7409281cdf6a60be90186d412c2be1"

  bottle do
    cellar :any
    sha256 "4f81e7cd663292f2f313d3f32748615c935c999ca821d63905e0f7d5872cc56f" => :high_sierra
    sha256 "0a2151ec4f734621335d8897efc686b3da30850a0d376f3e4429d5cf7c016df6" => :sierra
    sha256 "1e76be70156926a934dea21e45a3c8cb5e1da6b57c39ee925c3f818a580e6174" => :el_capitan
    sha256 "464498dac0ddb615680d42ff71a1eb98e4fbe6788313a48eda9b3c0fdafb3cb3" => :yosemite
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

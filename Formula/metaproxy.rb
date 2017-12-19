class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.13.0.tar.gz"
  sha256 "ed3d40058e0e36141bea7d7f0e39733a7b7409281cdf6a60be90186d412c2be1"
  revision 1

  bottle do
    cellar :any
    sha256 "408f6d7bb580c7b6d2d711880bcff51dbe59406471b55b5d4d6850476386ef9c" => :high_sierra
    sha256 "bb70a852e2efa08e6ffc54742b77a752051ad434c7b861139316f4de98d89ef0" => :sierra
    sha256 "922a0f6b49a6781620911d4b1ca22505b76474f2e7ba43ebca8285be484e97c6" => :el_capitan
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

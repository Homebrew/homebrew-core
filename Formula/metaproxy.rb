class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.19.1.tar.gz"
  sha256 "8861f9f3b44c2b170a4a00ed6861d49e0e5bbab9e3d736f939b9e2ca5e9b1b91"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "a209d1ac13cb8014558068155a556301ea9dd5067e69e6a986b9128070246628" => :catalina
    sha256 "8f4f2416e154d2e7f877dc68ce9dea75a26b0b3fa5f178cd0ff62dd7e50d5419" => :mojave
    sha256 "6cce930bf3e212fbaaab5cb521c3417474719e1289fbd7db9b2117fa943fc9a9" => :high_sierra
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

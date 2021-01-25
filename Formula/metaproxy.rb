class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.19.1.tar.gz"
  sha256 "8861f9f3b44c2b170a4a00ed6861d49e0e5bbab9e3d736f939b9e2ca5e9b1b91"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "77999b937db7fce7a23c222186faaf51df456a2b8b9cb344741cf652f13da536" => :big_sur
    sha256 "99d44edf3d390c5c370bb2e7fc70b2b2c133895c4a4472142c695fcdcf3dbbac" => :arm64_big_sur
    sha256 "8464920fa204d87a67e7c2f2ae1f09c0cad0065c7f04a9d1b3ad5a254c33b00d" => :catalina
    sha256 "4d1144c7c7b0bcd886eac667660611c10f233fc347db48c925dd45d2a528b303" => :mojave
    sha256 "1a36a5089c85d0c51c5a62b5c56a47d95d7e7345cc0cee44ef9a45a071091481" => :high_sierra
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

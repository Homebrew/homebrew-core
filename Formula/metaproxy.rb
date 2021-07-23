class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.19.4.tar.gz"
  sha256 "6d13b124023bcf6d5ba8f3891e071a804648c8fe608d12a38649cfaf2bde9851"
  license "GPL-2.0-or-later"

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "99d44edf3d390c5c370bb2e7fc70b2b2c133895c4a4472142c695fcdcf3dbbac"
    sha256 cellar: :any, big_sur:       "77999b937db7fce7a23c222186faaf51df456a2b8b9cb344741cf652f13da536"
    sha256 cellar: :any, catalina:      "8464920fa204d87a67e7c2f2ae1f09c0cad0065c7f04a9d1b3ad5a254c33b00d"
    sha256 cellar: :any, mojave:        "4d1144c7c7b0bcd886eac667660611c10f233fc347db48c925dd45d2a528b303"
    sha256 cellar: :any, high_sierra:   "1a36a5089c85d0c51c5a62b5c56a47d95d7e7345cc0cee44ef9a45a071091481"
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

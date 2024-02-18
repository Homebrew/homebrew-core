class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.21.0.tar.gz"
  sha256 "874223a820b15ee2626240c378eee71e31a4e6d3498a433c94409c949e654fae"
  license "GPL-2.0-or-later"
  revision 3

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6d4784de2b96d61bc2c9f70f980bc409336ec734de79cf9c9f7d8c799f8cddeb"
    sha256 cellar: :any,                 arm64_ventura:  "f3cc15c996632234d3cbf70c38b85a05263cb5582da0c0e5e899f572f02a5179"
    sha256 cellar: :any,                 arm64_monterey: "e7756b846c0e8dea56bbc369ff9fa673bf1e045f203fd6fba1b1a0c3a55fdc0c"
    sha256 cellar: :any,                 sonoma:         "1bafd1f9269564f8eb0978c2b8930a5d3aca02ff660c1346d6428937681da413"
    sha256 cellar: :any,                 ventura:        "b12c725a35515fb97114831b565e5d9f4a43ef0fb0cf13648a8cbaaf3c496e6d"
    sha256 cellar: :any,                 monterey:       "b729caf12f60fb6b55a1364445c4ce2828923c3b74168ac3c42c1921723f029c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65c2515f668da7f4a85a385acfaec0ba0949b5e851aa24a11afe66e72945fcd6"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yazpp"

  fails_with gcc: "5"

  def install
    # Match C++ standard in boost to avoid undefined symbols at runtime
    # Ref: https://github.com/boostorg/regex/issues/150
    ENV.append "CXXFLAGS", "-std=c++14"

    system "./configure", *std_configure_args
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

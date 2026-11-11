class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.22.5.tar.gz"
  sha256 "e3abcf302aecd05d53c11287df1a7330f6484320855ef626af090528bab61684"
  license "GPL-2.0-or-later"

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3081f8d1b59739530ea4bb6cf5114f793fb3e8e141957e8a63944fcaf507e63f"
    sha256 cellar: :any, arm64_tahoe:       "6030b95911ad0caf7ffc2b6d8c9736af0b99317d2a18a2a20111d31421d89076"
    sha256 cellar: :any, arm64_sequoia:     "d95442eb7c1570b70171f999c959193bba21861d11dcda4f822faa3b82575650"
    sha256 cellar: :any, arm64_linux:       "ea6738681e8dc60d7d66c0fc392cfbb791cecee147e509560156b2eedb186112"
    sha256 cellar: :any, x86_64_linux:      "19d1aef80a1809cbaabafcf63ea1f7d732a87f051124bb356265394d5e50d35f"
  end

  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "yaz"
  depends_on "yazpp"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  deny_network_access!

  def install
    # Match C++ standard in boost to avoid undefined symbols at runtime
    # Ref: https://github.com/boostorg/regex/issues/150
    ENV.append "CXXFLAGS", "-std=c++14"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  # Test by making metaproxy test a trivial configuration file (etc/config0.xml).
  test do
    (testpath/"test-config.xml").write <<~XML
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
    XML

    system bin/"metaproxy", "-t", "--config", testpath/"test-config.xml"
  end
end

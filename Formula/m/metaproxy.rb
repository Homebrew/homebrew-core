class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.22.6.tar.gz"
  sha256 "9d28790771a5591d546ec24b1b4df6894d9ff95031dcd3db9814f65636cc1081"
  license "GPL-2.0-or-later"

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9c51140d7ecfca5e7d1d759934596ab050bb82cbde37d065398ade10d5a911b4"
    sha256 cellar: :any, arm64_tahoe:       "a3b3de88d330fa735075471ad5e50262c57ef195c24c1e9b2c51ca829fec746d"
    sha256 cellar: :any, arm64_sequoia:     "2ecf2023469f197da35250a30bc93d2bb604995e094039fe753b7bc34e94f119"
    sha256 cellar: :any, arm64_linux:       "b3ed0ebf094790ab8ac8f6e0e9880e5ee32bafd4a052b54325cacbb293f09a8d"
    sha256 cellar: :any, x86_64_linux:      "9a2f0df20d599311fc2a96975a7479d6d495a1e0d14159bff6a44d0da08b971b"
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

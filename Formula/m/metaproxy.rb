class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.22.4.tar.gz"
  sha256 "79bffb2786bfd7612dab9603bd69ab1505c6d04053db192e0cc9ef6a842450dc"
  license "GPL-2.0-or-later"

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da764a2aa2f4422d55ba7c2317ffe1ba2928620fcbec50111530a2e8530ed598"
    sha256 cellar: :any,                 arm64_sequoia: "8a085a91ce428ef14bf365e49930137cd1d73e74a9897de8e0b783994205e644"
    sha256 cellar: :any,                 arm64_sonoma:  "48436f988260b712eddaba6c164c25e0e68971f22a5608374d31b0ccdbfae417"
    sha256 cellar: :any,                 sonoma:        "a6b6df0f143368c3b93e2a23cea794f7d3f980433ca5e0f95b87e452df8d679d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "357bc2d768f78f0a64d129544782027f66bf5270c40fab0e01fe96c242489416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85322e26a672f3b6a6f624a7d6d55c33b1e05aa6a01219a29a43967595b4db0c"
  end

  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "yaz"
  depends_on "yazpp"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

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

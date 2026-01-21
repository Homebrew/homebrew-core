class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.22.2.tar.gz"
  sha256 "7a48f3d7fd973b05205c1510a195cf5bb7a1de7b32feaeb51c36d29453cb8e76"
  license "GPL-2.0-or-later"

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a6da9596d210ec13c493238d6f79deabf95946a643b8b67056573e1fb038d17"
    sha256 cellar: :any,                 arm64_sequoia: "f90b1024edd43e984f35b223e2f995df5ae36a4fe8e176b64f9c511c1b51418b"
    sha256 cellar: :any,                 arm64_sonoma:  "6a808ab5b2d38bad82eb11591e60cf3c1e811a7d645625d12f76bde46c8f1a62"
    sha256 cellar: :any,                 sonoma:        "51615017734d4d779e9c591ab5cf00904de1cfedea3b154a3cb60a6217007895"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e045d3799327a186a6159a57aafbd97acb685b85176d4091fedd421fb9b04e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6fc83680b667e1444de569deb5f8456cbda0c033c2e9b2be749ad6b4703942"
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

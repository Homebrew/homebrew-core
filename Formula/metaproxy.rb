class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.20.0.tar.gz"
  sha256 "2bd0cb514e6cdfe76ed17130865d066582b3fa4190aa5b0ea2b42db0cd6f9d8c"
  license "GPL-2.0-or-later"
  revision 1

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8bd251c25b40cb964ac83fad38db949526ae6a4e460458a8c24c9d0dea937b2b"
    sha256 cellar: :any,                 arm64_big_sur:  "520ee4ee1c8f96cdd91ca31a6b77b49c3ee447273ad72c297bd687d3fe5c2aa9"
    sha256 cellar: :any,                 monterey:       "af5a2f792bfde97b3c303d6e59c518b189b75e9c44e18b8bfe9f656b80d93916"
    sha256 cellar: :any,                 big_sur:        "805b299b14498830c931071bb23e15125f8386046593947d92481b30c9dbb5e7"
    sha256 cellar: :any,                 catalina:       "bb29f5fb3c0e23ea29ab2d4a8104207711749d3e325116d758ecd0ebfc3bb3d2"
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

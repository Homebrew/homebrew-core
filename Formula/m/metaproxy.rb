class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.22.1.tar.gz"
  sha256 "d67a9f7fc9d36ccea8c4770c96c4ae2bc4250f484f941cbeec2a11695ec8d7b8"
  license "GPL-2.0-or-later"
  revision 1

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0fde30e0981972930b36cec80c9199fecc4d587e5500d3e5db86b793feebc066"
    sha256 cellar: :any,                 arm64_sequoia: "fac499e49d91fe8f9056887c49190c481701ab349351801c0cf214a278283f35"
    sha256 cellar: :any,                 arm64_sonoma:  "dc7dd1dab2e198f98ce502f952cc8ba62f76564400168210faa684caf34de6de"
    sha256 cellar: :any,                 arm64_ventura: "8c4fc4ab5fd41b9f8a3255965c5ee70cda3e82503e697658725572f587c23b78"
    sha256 cellar: :any,                 sonoma:        "e3d0259354592605d7fbbe51be7ea0e8cf011a96b81890c1d55dfc80a806abbb"
    sha256 cellar: :any,                 ventura:       "13923079d23db8b49cc6d1999ff465f7cd1ed26dd6db36dd3dd2b3a8cf52eb46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0007cf2d8f23ab1d9372bd3da36f46fbe2caf53fb333237e550ff46099dba18b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dc76a8d16502d41218106da2a8ef91facdfd393ef05bd69c9f15cc30399f6ec"
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

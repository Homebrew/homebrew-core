class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.22.4.tar.gz"
  sha256 "79bffb2786bfd7612dab9603bd69ab1505c6d04053db192e0cc9ef6a842450dc"
  license "GPL-2.0-or-later"
  revision 1

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bb7dd17aaa31d29f07e36c3c7c134664d0b98b934a062a32f44d1f5db56abc35"
    sha256 cellar: :any, arm64_sequoia: "27c686d53c31b2fda02e4d5d78351e160273406f8331c602adaba37822104f7c"
    sha256 cellar: :any, arm64_sonoma:  "6b8a78f19e896c498719dadc26d58585266601e940d232b7e59987088268936c"
    sha256 cellar: :any, sonoma:        "ac288d2d87e77596277973174c86a02796f867c88a6cc0de3888b53a9f392194"
    sha256 cellar: :any, arm64_linux:   "cd7c69ca1620a93dd5c124d59c417fa901b0d4daaf7b8519af03bfacf2bd76bb"
    sha256 cellar: :any, x86_64_linux:  "dfd64eb44a115381c59b5ff0c81bf991a56fcb5dc2f93d2671543676271c53cc"
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

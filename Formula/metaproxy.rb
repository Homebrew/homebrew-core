class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.20.0.tar.gz"
  sha256 "2bd0cb514e6cdfe76ed17130865d066582b3fa4190aa5b0ea2b42db0cd6f9d8c"
  license "GPL-2.0-or-later"
  revision 2

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2446fc514fb3551a7b105579a57aeefa38a812da1629df37515a699c568a328a"
    sha256 cellar: :any,                 arm64_big_sur:  "49029d50fa78508964c23614563ad7769f0fe375adfb4b0efcf48ed0b689a606"
    sha256 cellar: :any,                 monterey:       "0b2a53eca6621fd7c30097efe4a7fb81c063ec21916ea23b25733614a49916da"
    sha256 cellar: :any,                 big_sur:        "9e469f952edae1e99086c9276383f501b92407d81bfd1a94be7184a0865a5c4e"
    sha256 cellar: :any,                 catalina:       "d68cb245928089f4aef7f31cf637df806ff82977b30a14b883c1bd12c89e51f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe2764f8900ec32f834c1a7f1e0fcb094fbbc5f716363eb374ae50e22b25973f"
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

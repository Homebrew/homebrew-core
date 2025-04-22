class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.21.0.tar.gz"
  sha256 "874223a820b15ee2626240c378eee71e31a4e6d3498a433c94409c949e654fae"
  license "GPL-2.0-or-later"
  revision 7

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "28f9329e46a7b13cb0ed8846f05403beb96282642896f3f9b7f5f7b845e1caa2"
    sha256 cellar: :any,                 arm64_sonoma:  "ec5c8a54a7a15be703eac8db5fc4e17f0918e425d288280f4abab13d73a181d5"
    sha256 cellar: :any,                 arm64_ventura: "e1de1ffa03945b5b93f3b4b1fe77318725a7fbfdbe125b747cc184ede629166b"
    sha256 cellar: :any,                 sonoma:        "3eec9d1c5c0ca7a7d5be69a0e4054d22fd790d12c4badacc6243305569a83deb"
    sha256 cellar: :any,                 ventura:       "fd1bf937382f26e645c5647c72c69cb24d4e1a02159150dfe357ad254ac09e0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f547ae093c58bfce5805af8ca47e0f8b471ab4972990f8cf85a165c62582aff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be2d34b37b7a66a7e3f7357a5fcd98e3b1f56c7619fb6e3cb9721fefa7f2bc7e"
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

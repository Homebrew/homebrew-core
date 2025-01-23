class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.21.0.tar.gz"
  sha256 "874223a820b15ee2626240c378eee71e31a4e6d3498a433c94409c949e654fae"
  license "GPL-2.0-or-later"
  revision 6

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b1eea2b79dd905c1fcc7b5d1c3daaec3dbb29ae98a36a68ea71128283e0d58b9"
    sha256 cellar: :any,                 arm64_sonoma:  "0cb4b412383eb9e632b41098897d8c505ad2018afb37155ddcf4cf9e7fe9c680"
    sha256 cellar: :any,                 arm64_ventura: "0c1a59097b9950126974696be1aabcf0d2c3959708cefba9d2158f97219f6bf3"
    sha256 cellar: :any,                 sonoma:        "7a1adea81cd7b58bfa798904b4796b53c99fb99ebd8daf14729b3671a81e923f"
    sha256 cellar: :any,                 ventura:       "94c153a802f50a3b4c5e1e76df4688e7a1ae54ae305623f359e624dca063af29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaa7e3c1c3515d207a783e401edce6689990c08c649df23a57c3d7ffb5c1a695"
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

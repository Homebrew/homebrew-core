class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.21.0.tar.gz"
  sha256 "874223a820b15ee2626240c378eee71e31a4e6d3498a433c94409c949e654fae"
  license "GPL-2.0-or-later"
  revision 5

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1d4baa3427aecbd1822d325dd5772d0e5631a766ca818b4622194d4e8043d78e"
    sha256 cellar: :any,                 arm64_sonoma:   "ffb90c9755736aad5b6550da41cd76092c911bde384b2a861137bb75fe825931"
    sha256 cellar: :any,                 arm64_ventura:  "c7f1d531b20ce456abfc44a9e9bd3264e92886aa4c22078f8a40ad176d6eeb6a"
    sha256 cellar: :any,                 arm64_monterey: "324592b63eeaa2b09519704902931acd77873e4b3ffaac9eb8dcd464df6254bb"
    sha256 cellar: :any,                 sonoma:         "288a4377a1da730b21bb30abb69aa538f4e7e196c0c355a06b70dc9d8838083a"
    sha256 cellar: :any,                 ventura:        "3f39818e46442d8f649354b76a0c2cf332214b3437bd1881181330be0622c1cb"
    sha256 cellar: :any,                 monterey:       "50429ace6ef86b4ddf96da9ab950bdc40cf237662434fc61ff6f6a8f08d8c2b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6b0f7dfee1364a2b5fa6bed0444dfc973f393ba576c06840643967a5da1f64f"
  end

  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "yaz"
  depends_on "yazpp"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

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

    system bin/"metaproxy", "-t", "--config", testpath/"test-config.xml"
  end
end

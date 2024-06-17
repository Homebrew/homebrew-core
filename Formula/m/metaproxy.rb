class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.21.0.tar.gz"
  sha256 "874223a820b15ee2626240c378eee71e31a4e6d3498a433c94409c949e654fae"
  license "GPL-2.0-or-later"
  revision 4

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e274c6ff9b050bc69f7757144043126a577277ac1dd9f73bc566f30938599e53"
    sha256 cellar: :any,                 arm64_ventura:  "8568997fc0a3b038faff4e9201b6aac49ec5533b0a0fe4f4029ef2fd3b837189"
    sha256 cellar: :any,                 arm64_monterey: "7f4cdb23e8a63e1852bf0d1513b16b023bd250e899da40a36ba5811a7541c0a0"
    sha256 cellar: :any,                 sonoma:         "23e12dd6a57bf3fcb08f031d318201b2e3bb678389027da0aca42e62c7f0a129"
    sha256 cellar: :any,                 ventura:        "11f968e1e5c81e820b0f1854c4a815bc1ef817560a608bc17691f039541f7d74"
    sha256 cellar: :any,                 monterey:       "1e39db79eec1abf1f2db9d7e4eea0242037ba7e65dbfa6c2a56830316e76c6aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9a9d8dc0e5928d12482c4e8438c1f845b86eb19a0d534359be73fd6432ca667"
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

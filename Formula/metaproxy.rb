class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.21.0.tar.gz"
  sha256 "874223a820b15ee2626240c378eee71e31a4e6d3498a433c94409c949e654fae"
  license "GPL-2.0-or-later"

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5f55c3b73288a792bd8e4e7cf38c9fde4e21ad45a6a4961ab2d9957d42300570"
    sha256 cellar: :any,                 arm64_monterey: "dbf687afa69f52a53e63d5754b6bb30ea91f4673a1b72ec9f26bb6d5d62246ac"
    sha256 cellar: :any,                 arm64_big_sur:  "b281a369bc300ccefb7f2b15c72b15e842a72ada88f130b1a56f7cdb50d977f9"
    sha256 cellar: :any,                 ventura:        "91e4db798dd20206ff631c4939edf186c9d26efeea21cef0c1aaa83eb22946fc"
    sha256 cellar: :any,                 monterey:       "5defd04d977c66aab07001282f2442ddb802e7051f93887886ac989252c1e59d"
    sha256 cellar: :any,                 big_sur:        "11a728fd1a729c52c0b64127d34f8893d63bbcb05fc6b01a035fa4ab52bb9021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fe7bdef0f0db9b6ef4584c67da66416a38598cdd41a68ebaf434fb91576d82d"
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

class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.22.3.tar.gz"
  sha256 "db154f1d57e00769c59e676888be7610bde70e32ee179c8185bd9179f2b02811"
  license "GPL-2.0-or-later"

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a7eb460d7ec0ac7fb969b7f5a28fe294e07be6920f744cd3197bb65e82af295f"
    sha256 cellar: :any,                 arm64_sequoia: "e19f2ba6325e1dfd0a27a4e932dd091af4650c35b754518246dce8e8bfa3bf39"
    sha256 cellar: :any,                 arm64_sonoma:  "c36838976487a7d4858fab5553deb3fa08a78880768933535401b33254f36a33"
    sha256 cellar: :any,                 sonoma:        "697ab1129a23df310aa052b7fd07b2c763d920a4c84d82d08b682e7fed9ca101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "027749a6c0dac836bd413b5dee064ecc3ea1e71ad51b909f3f08e1c1fc7de864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93ab93973838c8a4537df846e886efb25da6e83adfdf38129ec611f0cb1a4e60"
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

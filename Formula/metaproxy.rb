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
    sha256 cellar: :any,                 arm64_ventura:  "698f5b0b8c0c7ac6d3694e76a7879222982900a2532f877ae110719113ae38cc"
    sha256 cellar: :any,                 arm64_monterey: "b7e2e5217f0d2a93bdbc219aa3d45b7e447f29b94d2a660e9ef33811100f2988"
    sha256 cellar: :any,                 arm64_big_sur:  "5f91675fef3bf72028a136d29320b40865ff0330014d8189eb19f7b076d1117c"
    sha256 cellar: :any,                 ventura:        "00819dcd6b64812a3fc96b2ccc7153609bd8ded42e856112185bf8ad3f27fe4d"
    sha256 cellar: :any,                 monterey:       "60c101d2a99d25cf1af4b575ed3ab42ff30f9310cbadec739c58494dc76d0ea3"
    sha256 cellar: :any,                 big_sur:        "e9bf39b713279a3424faeff61cc405f6372da84dfed11d75bf96760618c1b8a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f3b005198c728c7e052f88bb3ac96dd171375809fafb0944e4196e457b622de"
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

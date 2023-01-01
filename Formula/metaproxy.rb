class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.20.1.tar.gz"
  sha256 "6d5a86622d1aee88ac2711d7bd17ea7b29c8210ab7a851ae5d827c49a1878ce8"
  license "GPL-2.0-or-later"
  revision 1

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "885f8eb27913f00873bcbfa360407457792a059d01ab5f42b962f0c2cf0057ca"
    sha256 cellar: :any,                 arm64_monterey: "fee0dd1d5cc4be29c7edc429684e4f8ea15c2b15a53765386f323d7e4a3bf636"
    sha256 cellar: :any,                 arm64_big_sur:  "0c9ce0b489ab4975a14e4a0de2c430c3aab5fd60e97eb1935a9c33fefe8297d8"
    sha256 cellar: :any,                 ventura:        "c70a3907c0b92349e525a164ed5ec8be69a9fd47cdddfd813f38fd9a0916da33"
    sha256 cellar: :any,                 monterey:       "4276c205f39bb06e6a4bde02fe7c68e2ee6e3a7f9360ee3ad4a2f716119e421a"
    sha256 cellar: :any,                 big_sur:        "028ab6a680a6080e38d9b615a411397c0d29126dab5184b8f10e6d9b37b3e21a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f11f45172174d355ac31bd9deeba2ad02ec3b59413c18b23e3f6e93581cb79d"
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

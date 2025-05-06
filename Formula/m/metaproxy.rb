class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.22.0.tar.gz"
  sha256 "0e23e251509451170f26e7adf649fa8cc40bd9ade36cdac24a6045ec9efb93ac"
  license "GPL-2.0-or-later"

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7835fb6cae644ed2f39a5664c5666a9e99d0b3c2d933c66d8e409794563973b4"
    sha256 cellar: :any,                 arm64_sonoma:  "4fbd1191d8611e77b713ea885cfbb4943bc10ff9599c262231c20a0b765a3240"
    sha256 cellar: :any,                 arm64_ventura: "2ee377cd3bdd574ddccefa39c1684c91d4d05870997166109a0c036c8b10b90c"
    sha256 cellar: :any,                 sonoma:        "e239d6eb5b4aab05803d2577a9ad2a295608a87b8957158697c20cc87874c38d"
    sha256 cellar: :any,                 ventura:       "66b591ffa521626a5dfd61409ce25dfef21051920c7298dfaa600dd8fcda5643"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e26a07e78261675b72915ce44711749a706d54601c110db6cd6133bb18c7ea35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a5b8efcb37c726dd8284a18f67b95bc304be3c59f1487542ef157990a78eb16"
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

class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.22.1.tar.gz"
  sha256 "d67a9f7fc9d36ccea8c4770c96c4ae2bc4250f484f941cbeec2a11695ec8d7b8"
  license "GPL-2.0-or-later"

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cc491840e22486538a41b371ddf6f4ccb8a5d979319fb5b80d8b135b20cef13d"
    sha256 cellar: :any,                 arm64_sonoma:  "b6d34b512fbfde767f33c8f0481db3d9bce926b3fa8e243ddf33ddae776e1db2"
    sha256 cellar: :any,                 arm64_ventura: "c4f1b360f83e40c4bddda2a33765cfa9a889fb15e604d02924edc4b1a6b0da28"
    sha256 cellar: :any,                 sonoma:        "678f0f79e1f5c7b0dda4140c2e769b5ba31a7b409ef98ff042125794aee119ff"
    sha256 cellar: :any,                 ventura:       "d419856bdf031a9d82300b4e1d07711a2716ad6cc4bf7cca8dba4f5c3381f347"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84c0c0ccfd26ca56b7a4b07a2a593509ec3f3340e2d75e54e758df8c1d8af4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f942530680f0423e8faa116c235631349055ba5afa9b021352b582caf593bf0e"
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

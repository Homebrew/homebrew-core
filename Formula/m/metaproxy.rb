class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.22.1.tar.gz"
  sha256 "d67a9f7fc9d36ccea8c4770c96c4ae2bc4250f484f941cbeec2a11695ec8d7b8"
  license "GPL-2.0-or-later"
  revision 2

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f4956b09ae4b75d8cce231866f3d798e3878996906d6712ccdae7609b80965bd"
    sha256 cellar: :any,                 arm64_sequoia: "66f5507257723416ff71f532e0f1804919c40b692ff0faab53711708c773c900"
    sha256 cellar: :any,                 arm64_sonoma:  "a73f629780d3c6039abf65e7ccb84ab73e2601c768c1a150fdc0aecbaf60af36"
    sha256 cellar: :any,                 sonoma:        "bb1658d390545e44b15a185701954ee6e848cfad38b27a1472f0f2cb3e8b7c51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a241d61c986556b58b5a3713bcd5d6d05582e6dbe78ee7518c5de09efc8347cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae9d50c8de8c6250bb1ca5f28de2be040a2b929f9172be1fffb56e7743358279"
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

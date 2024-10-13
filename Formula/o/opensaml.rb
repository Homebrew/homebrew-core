class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.2.1/opensaml-3.2.1.tar.bz2"
  sha256 "b402a89a130adcb76869054b256429c1845339fe5c5226ee888686b6a026a337"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?opensaml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "68d8faa89a76b85aca34000c4badc0dd6e1ec630e29e6c63d5dc5e9b920ddcf8"
    sha256 cellar: :any,                 arm64_sonoma:   "238a7f4de009350d61edc3c434128edd6ed7f4a19063441e8ae1455fe6c1be9f"
    sha256 cellar: :any,                 arm64_ventura:  "59d3b421e0a08b0b04f60d2989c4ba8585ed77c09fcc36496d98767accafcdd3"
    sha256 cellar: :any,                 arm64_monterey: "751d88f288303ca0cff704f77cdb3803c0eb3b8e94c5486b6033cee5f491afc4"
    sha256 cellar: :any,                 arm64_big_sur:  "232720c15dc28288affe6b2d95389a4b6bff730968496c7685d10bf7e7eb0b3f"
    sha256 cellar: :any,                 sonoma:         "6855a1cea3738fcae481b8e2db0e46c760639c80e56c0c41acc12b980bb7279c"
    sha256 cellar: :any,                 ventura:        "923aa760bafc583d1e5cde80ed636fc84db55633eef41bc56798cc9ae3cd3872"
    sha256 cellar: :any,                 monterey:       "f7dc0a6e36997a7697213dca41d535b8c25fa2ac7b0aacc149fa4d9dcc5cb1df"
    sha256 cellar: :any,                 big_sur:        "f23d5a0f0058664a4957f6d84c7aa7eb63586674b51172192999b2754f59193b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79621d652d472952723b63fb9d038728d20ac5777b973cdb82bbb8054c96ff2b"
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "openssl@3"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.cxx11

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "see documentation for usage", shell_output("#{bin}/samlsign 2>&1", 255)
  end
end

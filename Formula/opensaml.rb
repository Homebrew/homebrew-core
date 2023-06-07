class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.2.1/opensaml-3.2.1.tar.bz2"
  sha256 "b402a89a130adcb76869054b256429c1845339fe5c5226ee888686b6a026a337"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?opensaml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "59c471816035a2f47ef027372917f6e5f00bde0f52be611a093d2776186a17b4"
    sha256 cellar: :any,                 arm64_monterey: "b54f6321b30636a85766bf79106da3fe6e6bd62a8175bbf33e2f4ffaa59e0092"
    sha256 cellar: :any,                 arm64_big_sur:  "3ac7e8b8d17a3fae75013ab5d3816a0825e5135b332be9fa232458bfd6d8f0e3"
    sha256 cellar: :any,                 ventura:        "fa48153d9e27c658e81878c800a691934d23070e4215d3582bf8225bf851756d"
    sha256 cellar: :any,                 monterey:       "d3cc32efd39b792501474e1b9c2fe49052fe0e37d5741c1b3b12889e49fb2425"
    sha256 cellar: :any,                 big_sur:        "bec1ebc0632d0234f4365a13175e9079d93f1bf7853af6016438dd62fbd04b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73cd63ee414c783833b7b055dcb6a0301db0844da0ba759a1a7f2933547c6cb1"
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "openssl@1.1"
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

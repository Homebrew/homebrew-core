class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.2.1/opensaml-3.2.1.tar.bz2"
  sha256 "b402a89a130adcb76869054b256429c1845339fe5c5226ee888686b6a026a337"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?opensaml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c48af4c61c2a3b0a6c6cb46f56b9b8d05f1f9368d27907319d885ea04a570b0a"
    sha256 cellar: :any,                 arm64_big_sur:  "28d745aaa6bc776ee02233852c46e2aeb4aceb7bebb18544616636afeb61867a"
    sha256 cellar: :any,                 monterey:       "c7f9c44ae738326f0366dde99338add598a3e591b884aef5b71989202b5296e8"
    sha256 cellar: :any,                 big_sur:        "220a34c0915da2d3641b88d96615138e7a5341d4e21cfa654300a6ccab16651d"
    sha256 cellar: :any,                 catalina:       "09eb04c9b5475a70c1cd95e13e349c30c650433a0908fb078cf99f7126c4c4c5"
    sha256 cellar: :any,                 mojave:         "24938a715d29e9db821774514452b5b1289ce243c5a48c1a492286234ed8c945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e53c8826b29cac8c08f2614cbf0bba2327982420ed7f0d3924149740858f21e5"
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

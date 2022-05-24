class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://launchpad.net/flowgrind"
  url "https://launchpad.net/flowgrind/trunk/flowgrind-0.8.0/+download/flowgrind-0.8.0.tar.bz2"
  sha256 "2e8b58fc919bb1dae8f79535e21931336355b4831d8b5bf75cf43eacd1921d04"
  revision 4

  livecheck do
    url :stable
    regex(%r{<div class="version">\s*Latest version is flowgrind[._-]v?(\d+(?:\.\d+)+)\s*</div>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "936a077b8e11db4f99e5058f066587c21422f031b9fce0b744497056eb2824ef"
    sha256 cellar: :any,                 arm64_big_sur:  "5197881bee816a11514b94fe4081de199060a9f97a21bab350cbfa299f438a4b"
    sha256 cellar: :any,                 monterey:       "0a3ef485aae774dca957e4546cbbbae4c3cf218049429bf8f3b1fd030467be6b"
    sha256 cellar: :any,                 big_sur:        "d9e948718dbc34b0d94b63bd7dac9f139558011c3a46e17caa8fc009b344afa4"
    sha256 cellar: :any,                 catalina:       "458cdff62eb81824a84f0303649766b48f42a2a04dd71f9708947134d887b721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3adf0b567ee925141f552e7c8bfc8efb552853f314bf0039e64c5e6ee01c87aa"
  end

  depends_on "gsl"
  depends_on "xmlrpc-c"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flowgrind", "--version"
  end
end

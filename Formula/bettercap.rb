class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.27.1.tar.gz"
  sha256 "dd4349a43486ec300a0f777f7c53b2fff608fb82dbba720c144b85538811405c"

  bottle do
    cellar :any
    sha256 "d671711af69e3ea4d63f0ddcfce9d60f74de578ac90647b8f491de25a430d974" => :catalina
    sha256 "e9cd810712a9fbe6b8876bafb388b44c524f2a681d490602d9fc0c67f22b4e5a" => :mojave
    sha256 "eb1719f702e76298d06f96e539e29de849382b68a9bc933cd151b40d4a144721" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  uses_from_macos "libpcap"

  def install
    system "make", "build"
    bin.install "bettercap"
  end

  def caveats
    <<~EOS
      bettercap requires root privileges so you will need to run `sudo bettercap`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    assert_match "bettercap", shell_output("#{bin}/bettercap -help 2>&1", 2)
  end
end

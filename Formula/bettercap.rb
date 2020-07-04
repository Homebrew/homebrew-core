class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.28.tar.gz"
  sha256 "5bde85117679c6ed8b5469a5271cdd5f7e541bd9187b8d0f26dee790c37e36e9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "93ceb9310c486462aa1d940fabfc290e059a5cfc2b80b711e2d6e13b5ad5dc82" => :catalina
    sha256 "88f0cb583f1c9f4975c76b31ef2c500feb3a7fc194a2c873847dc35ba4a58da0" => :mojave
    sha256 "a87e2e19f4a7e4a0f1393baa44a908cffbbc4114f13657e4e2a937e420d78aee" => :high_sierra
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

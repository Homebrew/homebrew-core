class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.32.0.tar.gz"
  sha256 "ea28d4d533776a328a54723a74101d1720016ffe7d434bf1d7ab222adb397ac6"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4b440d1cb6604bd834d56817364dd5d6f6335737ac94a1984bb2c790b8eab26b"
    sha256 cellar: :any,                 arm64_monterey: "1fb738ccae7f3e2257ee1a7311d355c3f7c9381a43a774bf06c892142c10a1a2"
    sha256 cellar: :any,                 arm64_big_sur:  "e52d4ecc4d9b34037d66f1399b4111f3753ac6fde6fdebb922170367d82578f2"
    sha256 cellar: :any,                 ventura:        "e3cf6595828271c75b2876a5b080e45b3b383d16d76482edffb8663ee70bdbaa"
    sha256 cellar: :any,                 monterey:       "18e97d317c9dd3f3561074f23fd83f748e68f1070a06ccb3548afbfde9962829"
    sha256 cellar: :any,                 big_sur:        "6ca4df5dc6af80e97961923613220f3930989b3b2ef2911609a719003500d613"
    sha256 cellar: :any,                 catalina:       "d719df24fe3a24f2712fd5e08027b20ec0cf4a1e3e9f659d1b085a0b23bc7ee8"
    sha256 cellar: :any,                 mojave:         "cb44f7b4fed4e8c10049d4e69f3745f78d07a70b03b77327b9e6d02e03e7c020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eee88cd3e242be845ff45289d6d350a5bbbe9bac3801c2a17665c770ba24492"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libnetfilter-queue"
  end

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
    expected = if OS.mac?
      "Operation not permitted"
    else
      "Permission Denied"
    end
    assert_match expected, shell_output(bin/"bettercap 2>&1", 1)
  end
end

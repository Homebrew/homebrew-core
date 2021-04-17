class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.31.0.tar.gz"
  sha256 "0ca3b7f623ee60d6a0fa2e3016b9eee1add2dde926f7c72c010bec5f5fbe15c4"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bd1b5c6b35214e21d673be995bb1e3f95603b2a4da070f7339988ba842c97956"
    sha256 cellar: :any, big_sur:       "25e60bb80d992060f541ca4c293f3c3dcdba67afbffc1163e53c8045cae6d8c1"
    sha256 cellar: :any, catalina:      "bdb84f9b48951b8eab791dc61cd260fff5564be441fb54d817f9ca40aa8d53cf"
    sha256 cellar: :any, mojave:        "24ad808776a2cc8a69e52651242a29e5e2c0705f8f802e208a36b75a488ff508"
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
    assert_match "Operation not permitted", shell_output("#{bin}/bettercap 2>&1", 1)
  end
end

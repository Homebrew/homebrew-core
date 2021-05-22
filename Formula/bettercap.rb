class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.31.1.tar.gz"
  sha256 "f37ffb8c13b9f0abccb7766c4ecbf295d6219aaf4dbf141e2b71c2a1c9cdc9aa"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "21cac594fc9ad940e90acd7c1e2d8c194936b676004a17908c161c84b7c47336"
    sha256 cellar: :any, big_sur:       "c49bbacb5e4765a8404fd0184506ccbfca2d45be2e6d866548f45bfcf73b4ffe"
    sha256 cellar: :any, catalina:      "34f21c198abaf051ddefc85c1b42decb5b6cbb1e99cb96a7fcc336ed094eea92"
    sha256 cellar: :any, mojave:        "64ff9cb3f98d46ea2248f8951868cd45c1d97e7c0f821d89589003a0570930cc"
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

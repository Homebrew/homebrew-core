class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.30.2.tar.gz"
  sha256 "efff2594ed9c7661f7ac344b20dfa69b27f7b0208b849779f794db1803865c1f"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2ccb9f57d8efc0504ff5886ad2606ab75efad31d19f274ce53bed21b8fe6a157"
    sha256 cellar: :any, big_sur:       "c6aadac876f016df2517cf1eef176dd4fccf7d6a0b6db07591d7661c85be4651"
    sha256 cellar: :any, catalina:      "7b6acc979cb84d9c0ac51a9698506c9fd4e46afd7148c02e26613a8b46646765"
    sha256 cellar: :any, mojave:        "e01b8343216a89d198f176b241211a360462303ccb3259c867e17cfdd3e9f438"
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

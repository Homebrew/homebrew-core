class Btpd < Formula
  desc "BitTorrent Protocol Daemon"
  homepage "https://github.com/btpd/btpd"
  url "https://github.com/downloads/btpd/btpd/btpd-0.16.tar.gz"
  sha256 "296bdb718eaba9ca938bee56f0976622006c956980ab7fc7a339530d88f51eb8"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b3755f2bf12645b508e65ca3fa6136879ad6e764f3e82fe2ed4c46285e3a7eb7"
    sha256 cellar: :any,                 arm64_big_sur:  "899a1e60fbe73ab6ed57bfec2e6903b76a52e7831cb0280c6a34d689473def17"
    sha256 cellar: :any,                 monterey:       "a43040f01bab4a4293988eea310f638c54d8cb5a82c41e8ce720c345cd9a64ac"
    sha256 cellar: :any,                 big_sur:        "bdbb56a74d359d9feb9a6258ff4feff869561ffa208251be9f1a4ab3f18d3939"
    sha256 cellar: :any,                 catalina:       "777f217d1d4cb87a8f4dae2bb1fdf3d62037561bd72f93fbb753674516870b0c"
    sha256 cellar: :any,                 mojave:         "0b479e7b812055a0ebbbae40c63624258044d74cb11a2d698392792a5b543e4d"
    sha256 cellar: :any,                 high_sierra:    "35042eba57182babbaff9f4a2eb1cbe891ebd82d2427a14926fd3617475da363"
    sha256 cellar: :any,                 sierra:         "6951afbf4af1e9d0df95f5d9260ef04eeb7e558cd2d58c3a429a99ad93c2dddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b2e4da63e65ec96199c8152d3e5e45f5c10c80d2f1e407c9cff9cd26a761ba9"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Torrents can be specified", pipe_output("#{bin}/btcli --help 2>&1")
  end
end

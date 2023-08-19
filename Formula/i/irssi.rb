class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.4.4/irssi-1.4.4.tar.xz"
  sha256 "fefe9ec8c7b1475449945c934a2360ab12693454892be47a6d288c63eb107ead"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "fd81cf719504dda54a2335a49c745870b6996326096ded24504094a0df531ae3"
    sha256 arm64_monterey: "837aed2e22573fca9cc4ca6d7ed520a0c05e8160aa0df094f5531f4e281c48eb"
    sha256 arm64_big_sur:  "d3b5e6066a0e40f5cf365ae955e30a26a110ea4ef4687c44b3e6d0ee6cb729e4"
    sha256 ventura:        "3301c9947b6a95f068203b20511d0df67bff7165420cd4360189558e4e3f7522"
    sha256 monterey:       "d2846432df35bd76a9f268bb77227494e4f3cb12904c8d5dcb67aceb58915c0a"
    sha256 big_sur:        "7c0df2821bcdc4e622b87b39ff409f68097cdc60834c8aaa98a7c513ff1ef830"
    sha256 x86_64_linux:   "be737d817ac2d417e733e9feee98f64ce76428928cdabd9e88bba235fb700dee"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bot
      --with-proxy
      --enable-true-color
      --with-socks=no
      --with-perl=no
    ]

    system "./configure", *args
    # "make" and "make install" must be done separately on some systems
    system "make"
    system "make", "install"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/irssi -c irc.freenode.net -n testbrew")
    assert_match "Terminal doesn't support cursor movement", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/irssi --version")
  end
end

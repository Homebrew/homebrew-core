class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.20.5.tar.gz"
  sha256 "82581408fd3fff3e017ad188e648ce6e935febc97f6bcd96945372638bfc7f13"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_ventura:  "bb5a5b6b5ab6973248fc31e515dd0c5aacd6b561da97147fad765147bad00cc2"
    sha256 arm64_monterey: "f9156532189d835e4f553e9a3a0f972b2a6d291f989e9081c60212d89b386d27"
    sha256 arm64_big_sur:  "bdb736636517a29186dbec1df79a6f052121b67a6303506a6c06f141844f3c2a"
    sha256 ventura:        "762b9c5121cac1f784cc5c13de3bafda6d2f0051b617c922a1c6e6ac8c0d596d"
    sha256 monterey:       "144c5ac14ba1feb3830233863ab58b22483bc305aee92f6a8c8273a9480a814e"
    sha256 big_sur:        "709394e33207ebbe85a3d2d38e3957908d85c7eabc229e8038d32cc17478d328"
    sha256 x86_64_linux:   "cbebe377274c394f94f8b570056c549486abd6d5541e4f7d942dbfd4582705c9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/openfortivpn"
    system "make", "install"
  end

  service do
    run [opt_bin/"openfortivpn", "-c", etc/"openfortivpn/openfortivpn/config"]
    keep_alive true
    require_root true
    log_path var/"log/openfortivpn.log"
    error_log_path var/"log/openfortivpn.log"
  end

  test do
    system bin/"openfortivpn", "--version"
  end
end

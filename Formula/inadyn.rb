class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSL/TLS support"
  homepage "https://troglobit.com/projects/inadyn/"
  url "https://github.com/troglobit/inadyn/releases/download/v2.10.0/inadyn-2.10.0.tar.xz"
  sha256 "58ca61afdc0554b63b3eba1265caa1049c783d0ccfdbabc98273266466d8f142"
  license all_of: ["GPL-2.0-or-later", "ISC", "MIT"]

  bottle do
    sha256 arm64_ventura:  "6b8253cd3c5d08cb1fae5aa4aa7bbc615ed9783cc48782b979fb951eb4b8b751"
    sha256 arm64_monterey: "086a2de0488d7686306eca87b9d12343cba8be9ccf98368cb1c027444bab06ee"
    sha256 arm64_big_sur:  "d6e580a78016e72d57f7c8ae6da22b32f95c06147d5242d05c976f6783f5da45"
    sha256 ventura:        "16719ab1899b624cf9e9707d64e3e1a0e3ad67b30ed762649abf33efedd07f14"
    sha256 monterey:       "be2051f96804540b7bfa6c4d8c83922331ec2348d290e817d1fe7ac268d534d5"
    sha256 big_sur:        "1b37f802a5b200470c67b63f0634cffdec331216cf294bebfb77714f353c8c0b"
    sha256 catalina:       "98bb14ca5540b81c0f6a9a7565ac1bbb974b3d26f2ed9d9b5abb366c9e4177ec"
    sha256 x86_64_linux:   "273fe788b95edd871e53da319f67221b49dc2b88dffef9be9b5ce62b7f84ad83"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake"    => :build
  depends_on "libtool"  => :build
  depends_on "confuse"
  depends_on "gnutls"
  depends_on "pkg-config"

  def install
    mkdir_p buildpath/"inadyn/m4"
    system "autoreconf", "-vif"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    system "#{sbin}/inadyn", "--check-config", "--config=#{HOMEBREW_PREFIX}/share/doc/inadyn/examples/inadyn.conf"
  end
end

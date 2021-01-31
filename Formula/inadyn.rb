class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSL/TLS support"
  homepage "https://troglobit.com/projects/inadyn/"
  url "https://github.com/troglobit/inadyn/releases/download/v2.8/inadyn-2.8.tar.xz"
  sha256 "820696b6227abfd1f8666317bf25e24f13ff6fd2aaa1d136c405d36b32f905f7"
  license all_of: ["GPL-2.0-or-later", "ISC", "MIT"]

  bottle do
    sha256 "674155428be4adb0f0dd91fd8175f9e2edd6d7a548f78d4e917e248be80fbdc0" => :big_sur
    sha256 "9b9e63b6e5cd159642349930fb423cb48385049ff4606895bb82962130dafaab" => :arm64_big_sur
    sha256 "15adb75ac20d48ad952fce27a06f8b8ce8728d5084b9e1b3632215aa7ed2fc64" => :catalina
    sha256 "0100708fe3e5bd57607af7168ba0a02e30d01a79e8af60f86be20717377b5153" => :mojave
    sha256 "892f0bb649feb54f000aa9b5c22a812aeff22b1530f5e54a8783896b88d9ced3" => :high_sierra
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

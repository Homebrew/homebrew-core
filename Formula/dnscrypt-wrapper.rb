class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.2.2/dnscrypt-wrapper-v0.2.2.tar.bz2"
  sha256 "6fa0d2bea41a11c551d6b940bf4dffeaaa0e034fffd8c67828ee2093c1230fee"
  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  bottle do
    cellar :any
    sha256 "2e5062ae764458c5b9a32ac3d5b28f074073820b023a8eb1982bed54bd815284" => :sierra
    sha256 "7ffa8f1939c272cef5632ad898c75f1488623da86a532261f57528e7312e64b1" => :el_capitan
    sha256 "44306e2ec5f7b41aefebfb20489f2f4d6cb5ff3f060a4dc56fb96276d88095fb" => :yosemite
    sha256 "f5bb409138b1444050c020f2baccc14615cdda17908b2db2094ad8105c1552d4" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "libsodium"
  depends_on "libevent"

  def install
    system "make", "configure"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/dnscrypt-wrapper", "--gen-provider-keypair"
    system "#{sbin}/dnscrypt-wrapper", "--gen-crypt-keypair"
  end
end

class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.3/dnscrypt-wrapper-v0.3.tar.bz2"
  sha256 "ec5c290ba9b9a05536fa6ee827373ca9b3841508e6d075ae364405152446499c"
  revision 1

  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  bottle do
    cellar :any
    sha256 "59c874097529e0452f179d7e4b28a615513e052aac90695bc0c11337488d1bca" => :high_sierra
    sha256 "1aade3b9e53552e46a05697643819e9d4b2ce0a0feea5aad91d4965d988c9831" => :sierra
    sha256 "de819d82dcafb4b28cddaf150e3773c2b65a9e1c3211a3d68b0b46c72581c8e2" => :el_capitan
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

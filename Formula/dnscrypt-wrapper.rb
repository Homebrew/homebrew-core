class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.3/dnscrypt-wrapper-v0.3.tar.bz2"
  sha256 "ec5c290ba9b9a05536fa6ee827373ca9b3841508e6d075ae364405152446499c"
  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  bottle do
    cellar :any
    sha256 "268ac696b183becf2ad001f937a3e9600f1c5f20c89585fac6c21bf83ab509d0" => :sierra
    sha256 "ef4e5a23248e73f8a1b06e6704e5b6fbd3f7720dd55b2a64394eb29ea41a9b12" => :el_capitan
    sha256 "7665c7555c22ad8faee36719e8b10535b064f1d16beda2501d8968ddfac95f00" => :yosemite
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

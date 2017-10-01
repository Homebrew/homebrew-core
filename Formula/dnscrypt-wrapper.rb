class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.3/dnscrypt-wrapper-v0.3.tar.bz2"
  sha256 "ec5c290ba9b9a05536fa6ee827373ca9b3841508e6d075ae364405152446499c"
  revision 1

  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  bottle do
    cellar :any
    sha256 "adc0b376897d8d3ee716cddfa3bcdc66447a4c2bf217a6fc3e1a4b0324e6279e" => :high_sierra
    sha256 "c877cf6c9d926a9414f14dbf97096001cadc1d2c2daf634e08a36003d4898e0c" => :sierra
    sha256 "4b502c8e15050c876280cbf50c277f4e6e57609152e04a63450f5c25effd1ced" => :el_capitan
    sha256 "ec06eb2055c8a812f08e2cb7783f431864baa77d2375775ba36bec730a1b585b" => :yosemite
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

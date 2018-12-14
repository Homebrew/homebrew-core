class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/cofyc/dnscrypt-wrapper/archive/v0.4.2.tar.gz"
  sha256 "911856dc4e211f906ca798fcf84f5b62be7fdbf73c53e5715ce18d553814ac86"
  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  bottle do
    cellar :any
    sha256 "f0db8bce27646ceac4165bfce815bd0268b50543b21632bd53aad1aaffd0af94" => :mojave
    sha256 "ea9ee8d3e27d21906fd1319ae23dcc42fd35d8b8833c558392db5b302870a24b" => :high_sierra
    sha256 "50da00dbfaa78a699d47f8c9f80818d6ae23149af86ba1e99e493b3748b50b0e" => :sierra
    sha256 "fd337e04cffac7af7eaf24b9a191bacd012a3b458d247d6a266274d0968702d3" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "libevent"
  depends_on "libsodium"

  def install
    system "make", "configure"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/dnscrypt-wrapper", "--gen-provider-keypair",
           "--provider-name=2.dnscrypt-cert.example.com",
           "--ext-address=192.168.1.1"
    system "#{sbin}/dnscrypt-wrapper", "--gen-crypt-keypair"
  end
end

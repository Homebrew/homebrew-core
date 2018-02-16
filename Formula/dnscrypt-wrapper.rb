class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/cofyc/dnscrypt-wrapper/archive/v0.4.0.tar.gz"
  sha256 "0b96a1f00a005aba8c167a16ff20f51d3747e3ae1651edf91731b7a240bb2539"
  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  bottle do
    cellar :any
    sha256 "19a0f9848cfade49ae311466bd75d9e546f531ca7518f060d4200048967f5268" => :high_sierra
    sha256 "10f726558f48d410ed176f33430d4111e64f1e3cfc487b1292d7331dd3277016" => :sierra
    sha256 "9e13f1a44fc46e749e35a0d3f2f43f6508b861753afd5ba55f7618e5188de315" => :el_capitan
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
    system "#{sbin}/dnscrypt-wrapper", "--gen-provider-keypair",
           "--provider-name=2.dnscrypt-cert.example.com",
           "--ext-address=192.168.1.1"
    system "#{sbin}/dnscrypt-wrapper", "--gen-crypt-keypair"
  end
end

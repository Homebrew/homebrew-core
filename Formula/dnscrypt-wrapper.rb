class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.2.1/dnscrypt-wrapper-v0.2.1.tar.bz2"
  sha256 "02f52859ec766e85b2825dabdb89a34c8d126c538b5550efe2349ecae2aeb266"
  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  bottle do
    cellar :any
    sha256 "b5d991a7ce7b3d7b2a8ea666059a528f763c1295d40b8b37fd57eb5adb3259b1" => :el_capitan
    sha256 "ef36926eb51988ec91e324006131259b31d9f5b63c11c73112d2b183160a69bd" => :yosemite
    sha256 "1801b7c0f26b2736c825f5225516629a2113e9a3df0c6852b36d40a6879e6d0e" => :mavericks
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

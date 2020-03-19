class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.3.0.tar.gz"
  sha256 "7a007d655d30f1edd001206839107e651966e1e519d53ba2c036491044111e97"

  bottle do
    sha256 "a1f78501e36816697c037ff8d08672971b8aefc84ee5afdad76382c5690ed4c0" => :catalina
    sha256 "365d92511cc39d4bcf0b901b2397d3e101a8e33a5d696c7bcda59063171799c6" => :mojave
    sha256 "780d020fd1f68ef2c132e6cd52ec8989b5f593b28ecf8a31515105566fd70598" => :high_sierra
  end

  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end

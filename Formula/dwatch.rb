class Dwatch < Formula
  desc "Watch programs and perform actions based on a configuration file"
  homepage "http://siag.nu/dwatch/"
  url "http://siag.nu/pub/dwatch/dwatch-0.1.1.tar.gz"
  sha256 "ba093d11414e629b4d4c18c84cc90e4eb079a3ba4cfba8afe5026b96bf25d007"

  bottle do
    rebuild 1
    sha256 "4778a3087b6ff2097975a9b552a2996c12b351ff8479d766b3a9ffca0b1075e1" => :sierra
    sha256 "937b2bdf39471f35f37fadccec316a1f719f51e9f47c6b2240cde6f5e3b948f3" => :el_capitan
  end

  def install
    # Makefile uses cp, not install
    bin.mkpath
    man1.mkpath

    system "make", "install",
                   "CC=#{ENV.cc}",
                   "PREFIX=#{prefix}",
                   "MANDIR=#{man}",
                   "ETCDIR=#{etc}"

    etc.install "dwatch.conf"
  end

  test do
    # '-h' is not actually an option, but it exits 0
    system "#{bin}/dwatch", "-h"
  end
end

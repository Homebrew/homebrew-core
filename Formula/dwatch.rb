class Dwatch < Formula
  desc "Watch programs and perform actions based on a configuration file"
  homepage "https://siag.nu/dwatch/"
  url "https://siag.nu/pub/dwatch/dwatch-0.1.1.tar.gz"
  sha256 "ba093d11414e629b4d4c18c84cc90e4eb079a3ba4cfba8afe5026b96bf25d007"
  license "GPL-2.0"

  livecheck do
    url "https://siag.nu/pub/dwatch/"
    regex(/href=.*?dwatch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_big_sur: "d685c1a752eea0246f6d5f5cc26a6594f36f1950112a3ed65934a52eb37185e9"
    sha256 big_sur:       "b7668fa89890e3a496c345d6c28e4c9fec9e9f36a0f6d8cd21c1b0bf4916d785"
    sha256 catalina:      "c79f51f4329569d682357a97014bd67a14ac1444e4fb983abd3a9e96339ba87a"
    sha256 mojave:        "69b3cb7cc60c1635c3134a0cd5e9dd884b3e28f52955e62da9beb0605e43cff5"
    sha256 high_sierra:   "fdf97f373c4bb18a3025d0f4acd9e16c826eca19cb60c9abd59d59bee8741c0f"
    sha256 x86_64_linux:  "0b92db3bb67c09bf3305bf60f11c6042b91406d80eba7937962c26abd1cb62e8"
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

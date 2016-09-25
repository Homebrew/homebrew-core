class Dwatch < Formula
  desc "Watch programs and perform actions based on a configuration file"
  homepage "http://siag.nu/dwatch/"
  url "http://siag.nu/pub/dwatch/dwatch-0.1.1.tar.gz"
  sha256 "ba093d11414e629b4d4c18c84cc90e4eb079a3ba4cfba8afe5026b96bf25d007"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba53e818fa75c684a88f3ce402266d44199ac4e3a67274b4bc788c1cdaca9c09" => :sierra
    sha256 "333be69806f30f6d169e79a7b59ff773d7c0b2e0d285e901a3fdb7c5c5e97ae7" => :el_capitan
    sha256 "fc0e151b4bf12ed2c1cfe714a09522965aa8f78e7a45d2f773e97b47d8c653f6" => :yosemite
    sha256 "f7fff9f814307bda8b0c6995c82a1114f0c62de23da90d754ef23edd5233d7f8" => :mavericks
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

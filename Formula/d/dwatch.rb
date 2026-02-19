class Dwatch < Formula
  desc "Watch programs and perform actions based on a configuration file"
  homepage "https://siag.nu/dwatch/"
  url "https://siag.nu/pub/dwatch/dwatch-0.1.1.tar.gz"
  sha256 "ba093d11414e629b4d4c18c84cc90e4eb079a3ba4cfba8afe5026b96bf25d007"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://siag.nu/pub/dwatch/"
    regex(/href=.*?dwatch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:    "d8916e526f70eb17c0010715a61c5746c20214fe8210f544f50650358ab1bb0a"
    sha256 arm64_sequoia:  "5a80233a94231468b47d75de46c5687c8c274771ead2c2131634c7acc224390f"
    sha256 arm64_sonoma:   "615de415e77a4739ef13fa2b3de259c3974409c5b94436b852fcb3e563706e2f"
    sha256 arm64_ventura:  "77ffa4908916dc6f0777a4c04e56bfa3009b4bc9472881830c84c07f926fe3e6"
    sha256 arm64_monterey: "496581eb99331049567945d3772d07f035a21f5275cf0408183dfb87375b6f6a"
    sha256 arm64_big_sur:  "d685c1a752eea0246f6d5f5cc26a6594f36f1950112a3ed65934a52eb37185e9"
    sha256 sonoma:         "3d02d6d8d63ddd202f183606952f6f4ac28c8860851477ab0b11618242c432a3"
    sha256 ventura:        "e4be73a2e05f83a381a97642543c740ce26669977c01d1bd4eb25ccfb50440ca"
    sha256 monterey:       "4d4101090f01137e1af3a2f8c377fd5763f7132f70f5959ccdc1ee96c5679144"
    sha256 big_sur:        "b7668fa89890e3a496c345d6c28e4c9fec9e9f36a0f6d8cd21c1b0bf4916d785"
    sha256 catalina:       "c79f51f4329569d682357a97014bd67a14ac1444e4fb983abd3a9e96339ba87a"
    sha256 arm64_linux:    "ad2ec3e48c3d41dca4e01b27147bb4dc1eefbdad07a102c3a3eebd6f34dab0ef"
    sha256 x86_64_linux:   "0b92db3bb67c09bf3305bf60f11c6042b91406d80eba7937962c26abd1cb62e8"
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
    system bin/"dwatch", "-h"
  end
end

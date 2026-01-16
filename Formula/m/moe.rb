class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "https://ftpmirror.gnu.org/gnu/moe/moe-1.15.tar.lz"
  mirror "https://ftp.gnu.org/gnu/moe/moe-1.15.tar.lz"
  sha256 "41f8c8b099ce3047945ca4e097a60d9243e9c73fbb268c194a12da8b0d9f0a66"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "5c20e2b669488844badcd5e9930273169528983a1d7f6c7814b6e1af438683d0"
    sha256 arm64_sequoia: "0d2e867872c06762566dec24fc623e2fadb8fd67ad80d50340f44a5e6fd39ae9"
    sha256 arm64_sonoma:  "028de034fd8e2a0b5543c925900e16b806d7d01ab49b77e61342641ace78c50a"
    sha256 arm64_ventura: "70dc3b3b0c9337c7efab45da9db577c7aa2554e0c50d2668d754cbd38f6b752d"
    sha256 sonoma:        "324720fab1db409bc494db46c0ccb9e2ed161c4168fc74197719ef0fba991094"
    sha256 ventura:       "dc04a4a8eb7b4c07651af6f21bf6aece52348a65c7255b7fd319ba7ebfe31949"
    sha256 arm64_linux:   "3ec690416ba55579babc7dd64f3a5ff9b2b1edaada6dbdcf0b8c6e6a7552a782"
    sha256 x86_64_linux:  "bf9f6ae698842d4b0b673c761e5bf77292a33bc2b88c19ecde04d923eadbff0c"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"moe", "--version"
  end
end

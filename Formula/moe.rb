class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "https://ftpmirror.gnu.org/moe/moe-1.8.tar.lz"
  mirror "https://ftp.gnu.org/pub/gnu/moe/moe-1.8.tar.lz"
  sha256 "7eff4ef2197d8febec99ad4efd4e277b1f3b7d4660f75e3b42b8818bc6bb6457"

  bottle do
    sha256 "ea1f7bb4dbef20f008080efde88a218d9f30428b7b54ca2e6657b16090549807" => :sierra
    sha256 "feea70d7c37c302d0992a50c04e3c47b43f0404decc6bf651cf8fcaba46fa562" => :el_capitan
    sha256 "4428475d4364b8dfd1a6fb34d4883eb6fce35b8a88bfab8675683f5f13127714" => :yosemite
    sha256 "0ebf4f6c5ef42d83cdc2a2a129ebe9554c55ca807fa1be03f7d9b4f454719d55" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/moe", "--version"
  end
end

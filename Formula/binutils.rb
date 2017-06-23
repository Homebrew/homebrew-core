class Binutils < Formula
  desc "FSF/GNU ld, ar, readelf, etc. for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.28.tar.gz"
  sha256 "cd717966fc761d840d451dbd58d44e1e5b92949d2073d75b73fccb476d772fcf"

  bottle do
    rebuild 1
    sha256 "ccacdbe617addcb6f41c2fba544077987ecd2dca62cf6c7884b0bfc639f99d45" => :sierra
    sha256 "7674e8693c4af0a738c721bbb530e432f5258d516a780c109c5d1ce0458e0de3" => :el_capitan
    sha256 "1b48a19196ea84d7c2d0fcfc933967b9d1596dd5f30935948ee0d5baaa9f6f65" => :yosemite
  end

  # No --default-names option as it interferes with Homebrew builds.

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "main", shell_output("#{bin}/gnm #{bin}/gnm")
  end
end

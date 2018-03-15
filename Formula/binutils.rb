class Binutils < Formula
  desc "FSF/GNU ld, ar, readelf, etc. for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.30.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.30.tar.gz"
  sha256 "8c3850195d1c093d290a716e20ebcaa72eda32abf5e3d8611154b39cff79e9ea"

  bottle do
    sha256 "2eff47fc3b2074c2ad67a288ce07a38daa611dbaa39fc9c27f89f7fb74e80972" => :high_sierra
    sha256 "0d9b3fc064c9a442bf3373771f200e4c78a269541a41e5be981c069deca30ce4" => :sierra
    sha256 "525681da15ff697938626ffa15748b9b7ebb46f0b24c5e35c802173065dbc9d7" => :el_capitan
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

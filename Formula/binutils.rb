class Binutils < Formula
  desc "FSF Binutils for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/binutils/binutils-2.27.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.gz"
  sha256 "26253bf0f360ceeba1d9ab6965c57c6a48a01a8343382130d1ed47c468a3094f"

  bottle do
    sha256 "61d1a4e3bdc1846267c984b478e3a5a822a8a14a1169153670a9a61402ab1d40" => :el_capitan
    sha256 "daeccb1d2c5c4b324aa5ea38c6813ead25d9bfea8a84e093cc96687fa152b3e0" => :yosemite
    sha256 "f2ae1527a595586195d773323a661135ce5a8eb96ec171ef5c387d1da5592d80" => :mavericks
  end

  # No --default-names option as it interferes with Homebrew builds.

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
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

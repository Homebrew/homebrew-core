class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.7.tar.gz"
  sha256 "bb8519313933656c1e55e4f1ab3204748c26671d058e8aadd8e30a8053eadebf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "7fc59ef6110976e7b0c8bb3dcb3e484c5f948d67fb1ab9cc59295906ca36cd99"
    sha256 big_sur:       "7ab8672696881b32d56597ede911c2fdf75d3e0cd531aa50efdfd2b3abcac008"
    sha256 catalina:      "a94e3a7512811b97aca338ed4cbf092d7ad59f2b8a6d82b263e20da73c7a9334"
    sha256 mojave:        "89e7d4a50bd75dec380935ab910ae741c6fdd9c5b67c8e1e044a8f8f8d36d2ce"
  end

  depends_on "argp-standalone"
  depends_on "libgcrypt"

  def install
    # Hardcode CPP_FOR_BUILD to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    inreplace "man/Makefile.in",
      "$(CPP_FOR_BUILD) -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre $@",
      "clang -E -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre > $@"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end

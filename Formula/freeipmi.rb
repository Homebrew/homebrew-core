class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.7.tar.gz"
  sha256 "bb8519313933656c1e55e4f1ab3204748c26671d058e8aadd8e30a8053eadebf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "9b9cf442de57271b2a7d338e4828669da746e2a80fbfd7e5feee5108160262a4"
    sha256 big_sur:       "f34294d363284a09e5852070f2c73cdafcb9a94ce584c83a30c82b3451541433"
    sha256 catalina:      "ff69947a14d7d273349f9f5219b55b8581fee4745c3571fb27f790307f1647a5"
    sha256 mojave:        "47441cb06fdfae9277c2760f43ba0236020de8906e9ead7bf4e1dc2569f2abc4"
    sha256 high_sierra:   "836d80487ea7790b95c951c48a9a7f9788117e254a55c1f6417c5a2455695f5c"
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

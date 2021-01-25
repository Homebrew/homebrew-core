class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.6.tar.gz"
  sha256 "cfa30179b44c582e73cf92c2ad0e54fe49f9fd87f7a0889be9dc2db5802e6aab"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "f34294d363284a09e5852070f2c73cdafcb9a94ce584c83a30c82b3451541433" => :big_sur
    sha256 "9b9cf442de57271b2a7d338e4828669da746e2a80fbfd7e5feee5108160262a4" => :arm64_big_sur
    sha256 "ff69947a14d7d273349f9f5219b55b8581fee4745c3571fb27f790307f1647a5" => :catalina
    sha256 "47441cb06fdfae9277c2760f43ba0236020de8906e9ead7bf4e1dc2569f2abc4" => :mojave
    sha256 "836d80487ea7790b95c951c48a9a7f9788117e254a55c1f6417c5a2455695f5c" => :high_sierra
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

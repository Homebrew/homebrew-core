class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.5.tar.gz"
  sha256 "61f2d6bc6c68f71701e7f3c725f43121705e54cfdc0c7800565d9443900e8ed9"
  license "GPL-3.0"

  bottle do
    sha256 "b9f840759c2573e79707d7010217d1814fd96737857a76bc25c68cc4a9e7aff4" => :catalina
    sha256 "a0ca63ac6b49e9f0b09a513982e34f94f7c2aa7d7345fc1009459d9fd8dfbd5a" => :mojave
    sha256 "65484065d4f8f4056af2dfa8c28cceb9e83b19ec5cbeec50a955af0be794a7c3" => :high_sierra
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

class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.1.tar.gz"
  sha256 "a2550e08e1f2d681efe770162125ac899022a6acf96256e5b7404eabb90db549"

  bottle do
    sha256 "a510f28794572ed659d6e709b44ee45d96d5c662d730084442d99771bca9d1ff" => :high_sierra
    sha256 "41c5cf3544953f6127dc312f09d08b8bfac2f551f298880a40e45cc260fac9bd" => :sierra
    sha256 "e008f84b3ef595205d47a81c6abcb32cbdbc7704ede7cd462dba41be292b963e" => :el_capitan
    sha256 "85d35f29c9f0be5849c6e7b6a8b6ef4f19c988a63edbe830240ea676f430422f" => :yosemite
  end

  depends_on "argp-standalone"
  depends_on "libgcrypt"

  def install
    inreplace "man/Makefile.in",
      "$(CPP_FOR_BUILD) -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre $@",
      "$(CPP_FOR_BUILD) -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre > $@"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end

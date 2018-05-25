class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.2.tar.gz"
  sha256 "31513324591bf8d79d7cdeb39ecfac45e0ea7f6a5905a625a4a906fb8270124a"

  bottle do
    sha256 "8207aeb80d22ca0541c0349c35fcdff37fe3869c00d7fcf7123701e05b472740" => :high_sierra
    sha256 "5f227003a4400e64fe8ead0c81ac88e978dbe54e3af8c31f54e9a4aa2500391f" => :sierra
    sha256 "5cb26ba42f5d9b5219299408ee38562cf6e146a36c2c7351965442eaa6336f2a" => :el_capitan
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

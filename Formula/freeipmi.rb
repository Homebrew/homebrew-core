class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.5.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.5.5.tar.gz"
  sha256 "ae20b98d145b6316c4231903a64a96954bdd718e74fc4e6cec2cd0b63edcff53"

  bottle do
    sha256 "2599fe01dd1194c6c79de17b80904e894ba6f86f11ef5f3525750a9d3bfaddf9" => :sierra
    sha256 "86f106bd02c86df03d9495b4c4a2dffa625ad0e6ac6da960302fd58d0a03fb73" => :el_capitan
    sha256 "aa6c2ea002a1950e92bc54209100e4784b191f393e761c5773fb724bc9705eb2" => :yosemite
  end

  depends_on "argp-standalone"
  depends_on "libgcrypt"

  def install
    inreplace "man/Makefile.in",
      "$(CPP) -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre  $@",
      "$(CPP) -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre > $@"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end

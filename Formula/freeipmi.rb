class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.5.5.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.5.5.tar.gz"
  sha256 "ae20b98d145b6316c4231903a64a96954bdd718e74fc4e6cec2cd0b63edcff53"

  bottle do
    sha256 "10175ab2910290da06778de67caba1cccdc508326fb4041398b18504fa6eac1b" => :sierra
    sha256 "84788ec75638ec29da7aae09a2a893bed7195a7b6da2f075805e9d1098a44783" => :el_capitan
    sha256 "16c84f699055978e35a434cf0d4ac6095b307adfce98ab9cab592b8f5a3effbd" => :yosemite
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

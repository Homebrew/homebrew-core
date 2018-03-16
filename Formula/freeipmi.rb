class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.1.tar.gz"
  sha256 "a2550e08e1f2d681efe770162125ac899022a6acf96256e5b7404eabb90db549"

  bottle do
    sha256 "f3d7dc8e36966d926168eac8a090c2c8072b2bea4d1175ee352c2747166a63cf" => :high_sierra
    sha256 "87783a9f0ec06d3eb6f7538c9c5e35f0c89654c95dbfcace5f432143e497f987" => :sierra
    sha256 "f7647ccef7ba495d020d1a6bd8a07d8b0433419bd6136e048a834af8b9d08241" => :el_capitan
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

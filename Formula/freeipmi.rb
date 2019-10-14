class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.4.tar.gz"
  sha256 "65dfbb95a30438ba247f01a58498862a37d2e71c8c950bcfcee459d079241a3c"

  bottle do
    sha256 "551747c4136dba2a5e7a3d2471ab3cd6c892d31d58edd228401ac3df8b216828" => :catalina
    sha256 "fed9113f307777c41efc5b186a391074c102462ea92dc84e01aef556c98cfa0a" => :mojave
    sha256 "23643e72d5d7fbef4a0c221fb212a5f771cb83e7062674870948d099b60f8560" => :high_sierra
    sha256 "6d74fb59533b218f658926705ca08ad8dbf7ce0cd95d0e0e1f4161359c2401a1" => :sierra
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

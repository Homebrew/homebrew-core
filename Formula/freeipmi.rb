class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.4.tar.gz"
  sha256 "65dfbb95a30438ba247f01a58498862a37d2e71c8c950bcfcee459d079241a3c"

  bottle do
    sha256 "b7a23d63dd67f2a59b0e800585ef0a37bf7f91a1c65eeb9582afbddf8f0931e4" => :mojave
    sha256 "832094c520391475d83f243e34d2358d0d6cf06bd7504177f8bb827b7417a9b1" => :high_sierra
    sha256 "7097c6a7836a71f18b4880ba0ec530872e2eca67276ffdb7b5e65fc646ecac88" => :sierra
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

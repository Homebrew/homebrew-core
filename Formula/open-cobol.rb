class OpenCobol < Formula
  desc "COBOL compiler"
  # Canonical domain: opencobol.org
  homepage "https://sourceforge.net/projects/open-cobol/"
  url "https://downloads.sourceforge.net/project/open-cobol/open-cobol/1.1/open-cobol-1.1.tar.gz"
  sha256 "6ae7c02eb8622c4ad55097990e9b1688a151254407943f246631d02655aec320"
  revision 2

  bottle do
    sha256 "633c325469f52c99c437a44dc2647e18fd8a841caa1779e1443cef1b898d1b75" => :mojave
    sha256 "c4f335dae8e5235f9615a87a018fe89b05857974023ff1973ec198705b3cd44b" => :high_sierra
    sha256 "c05a8ff66d8ad775049c2e1f400c4bde52d7f0ec13d7b2b40d94d9fc4b451c01" => :sierra
    sha256 "c9fc1e375ec061b9a90a5cc29446a61fe7f49e75d1a78c6888adee889e9258d5" => :el_capitan
  end

  depends_on "berkeley-db"
  depends_on "gmp"

  conflicts_with "gnu-cobol",
    :because => "both install `cob-config`, `cobc` and `cobcrun` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end

  test do
    system "#{bin}/cobc", "--help"
  end
end

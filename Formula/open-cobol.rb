class OpenCobol < Formula
  desc "COBOL compiler"
  homepage "http://www.opencobol.org/"
  url "https://downloads.sourceforge.net/project/open-cobol/open-cobol/1.1/open-cobol-1.1.tar.gz"
  sha256 "6ae7c02eb8622c4ad55097990e9b1688a151254407943f246631d02655aec320"

  bottle do
    sha256 "5803c69bb9b04d1fdebd4aa8a3e2b211a97ec3e8bc8e50f3918635d367d9d1bf" => :sierra
    sha256 "31b5e3af55285483f2e73463aa58cf35afae5a5ee675b7622703d62c34bbe529" => :el_capitan
    sha256 "a36ae3bbf6eabe5b5119f489b41d26a0bb03ae0aa6935a597ebeb046eea32da7" => :yosemite
    sha256 "64e3bb2cd22d0b95e4b143191d7dc2c3b245edef0f9a61e0cee366dc96723a77" => :mavericks
  end

  depends_on "gmp"
  depends_on "berkeley-db"

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

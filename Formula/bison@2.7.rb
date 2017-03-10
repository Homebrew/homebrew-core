class BisonAT27 < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftpmirror.gnu.org/bison/bison-2.7.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/bison/bison-2.7.1.tar.gz"
  sha256 "08e2296b024bab8ea36f3bb3b91d071165b22afda39a17ffc8ff53ade2883431"

  keg_only :versioned_formula

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

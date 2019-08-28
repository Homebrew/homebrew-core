class Fetchmail < Formula
  desc "Fetch mail from a POP, IMAP, ETRN, or ODMR-capable server"
  homepage "http://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.3/fetchmail-6.3.26.tar.xz"
  sha256 "79b4c54cdbaf02c1a9a691d9948fcb1a77a1591a813e904283a8b614b757e850"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3be3279ed30d08cdf4e533ec9ebad92398cea90a8f364851f82d5666b89bf25a" => :mojave
    sha256 "8e037ee9a367c9c4a26d5491e4db84285390d0ef1949c30d56c0726706dab6de" => :high_sierra
    sha256 "63692fabb3746b739ce3b81f2d1ce964ca4e74613ea63f307e734f90dbcea513" => :sierra
    sha256 "663d68d69a865daa6311f70ed2412abe79affa23b8fd76b44eaca5d9735fba36" => :el_capitan
    sha256 "44c0f861ca7a8bf1af2bd5c1007a48e397bba3c8dfeb7c3a3cc5299dd1cb7c66" => :yosemite
  end

  depends_on "openssl" # no OpenSSL 1.1 support

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end

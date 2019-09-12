class Fetchmail < Formula
  desc "Fetch mail from a POP, IMAP, ETRN, or ODMR-capable server"
  homepage "http://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.3/fetchmail-6.3.26.tar.xz"
  sha256 "79b4c54cdbaf02c1a9a691d9948fcb1a77a1591a813e904283a8b614b757e850"

  bottle do
    cellar :any
    rebuild 2
    sha256 "3c89f0974f8c6faa41f058021cc3042431480368b4c51b1bf6cd661922b08a10" => :mojave
    sha256 "57067a052d565f732ec06f939f613ad9de3a7ed1496a671f7d5d8ea9f9dbb253" => :high_sierra
    sha256 "bbb488da8deef2cf53d35034a9e9b058070dc671645ca1fb86698110050c13f7" => :sierra
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

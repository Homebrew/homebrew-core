class Fetchmail < Formula
  desc "Fetch mail from a POP, IMAP, ETRN, or ODMR-capable server"
  homepage "http://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.1.tar.xz"
  sha256 "3f33f11dd08c3e8cc3e9d18eec686b1626d4818f4d5a72791507bbc4dce6a9a0"

  bottle do
    cellar :any
    rebuild 2
    sha256 "3c89f0974f8c6faa41f058021cc3042431480368b4c51b1bf6cd661922b08a10" => :mojave
    sha256 "57067a052d565f732ec06f939f613ad9de3a7ed1496a671f7d5d8ea9f9dbb253" => :high_sierra
    sha256 "bbb488da8deef2cf53d35034a9e9b058070dc671645ca1fb86698110050c13f7" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end

class Lynx < Formula
  desc "Text-based web browser"
  homepage "https://invisible-island.net/lynx/"
  url "https://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.9rel.1.tar.bz2"
  version "2.8.9rel.1"
  sha256 "387f193d7792f9cfada14c60b0e5c0bff18f227d9257a39483e14fa1aaf79595"

  bottle do
    sha256 "5ed51f73503eba9fdf630ea91c24c191b9230eafa39d0ee240fb790056f75eb7" => :high_sierra
    sha256 "2ed655dd04dabb0c29f11ba03b5ebb7596bd68245e2dfda4a250535b30b2859b" => :sierra
    sha256 "9fa00d4125027a970354369f3460c013da95aa4fd6d81456711da1692e1a454f" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-echo",
                          "--enable-default-colors",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--enable-ipv6"
    system "make", "install"
  end

  test do
    system "#{bin}/lynx", "-dump", "https://example.org/"
  end
end

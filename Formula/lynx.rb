class Lynx < Formula
  desc "Text-based web browser"
  homepage "https://invisible-island.net/lynx/"
  url "https://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.9rel.1.tar.bz2"
  version "2.8.9rel.1"
  sha256 "387f193d7792f9cfada14c60b0e5c0bff18f227d9257a39483e14fa1aaf79595"
  revision 1

  bottle do
    sha256 "b7b36f0697736fc1744026c18968bec4d5c1433356678e853d734406f9dc3612" => :catalina
    sha256 "3b4c3a636d19106a2fea571889a4159fd49b82fbd2694c206d4851b15281fddd" => :mojave
    sha256 "68eb083eff0962b83dc121e9194d430d4e9c2eb7d559cb998ba992da9b566479" => :high_sierra
    sha256 "b8ee13323a4e8760f21a82da3b579d3373e282398ff7efe56c7ec8ae9cb0d064" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-echo",
                          "--enable-default-colors",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--enable-ipv6"
    system "make", "install"
  end

  test do
    system "#{bin}/lynx", "-dump", "https://example.org/"
  end
end

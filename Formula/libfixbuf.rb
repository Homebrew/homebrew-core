class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.4.0.tar.gz"
  sha256 "bf20f9f7986a525ea6cc648d32f4ba30bfeb2a83f8c830bc39c48dfa7a415175"

  bottle do
    sha256 "835aeb4089c8add19f4c9c56be373559f15c7c5134bc555988cab4244c9f9ca4" => :catalina
    sha256 "72d1509d9b0bea98eb09e2fd2aaaff75a2a8bddbef035ee5c244578ccf247832" => :mojave
    sha256 "a7bd2c731284fd783a6b1cc74efc0d7b3e3668b6b02afc33ce307aba8a2b3845" => :high_sierra
    sha256 "cd6ba9552c12bfb738591876977a2470c6132c3fa649d542f9a9a064ffa64488" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end

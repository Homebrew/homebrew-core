class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "https://research.wand.net.nz/software/libtrace.php"
  url "https://research.wand.net.nz/software/libtrace/libtrace-4.0.3.tar.bz2"
  sha256 "3c0842ba6a7674c51b3bf1ba474dd3cdd2df9fbcd2147d3216fed2b613377397"

  bottle do
    sha256 "e3163c0a23c6b925f23e08af6e4327caea0a9cf89198250bd7537bfb62bb2e1a" => :high_sierra
    sha256 "c1db3822e5b92a5e510a24f72747bc7008bbb435c9d44d07b659d0e56ed481ac" => :sierra
    sha256 "00e09353486c73d122c9743bcfad7a4379bbc1706896e25bc04e7ef925c36a7c" => :el_capitan
  end

  depends_on "openssl"
  depends_on "wandio"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

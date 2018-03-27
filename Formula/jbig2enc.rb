class Jbig2enc < Formula
  desc "JBIG2 encoder (for monochrome documents)"
  homepage "https://github.com/agl/jbig2enc"
  url "https://github.com/agl/jbig2enc/archive/0.29.tar.gz"
  sha256 "bfcf0d0448ee36046af6c776c7271cd5a644855723f0a832d1c0db4de3c21280"
  head "https://github.com/agl/jbig2enc.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b962a5771955a2926ba066ade4fd379df745b4afc8f2ee74d0f1429294cca275" => :high_sierra
    sha256 "0d092aaa3d99143057610d44328dda7ca35549f9a80683b637a5265d26e0cffd" => :sierra
    sha256 "6164ddfa8f877e4d8cacbe4437d8dd5ec10465910446cb43e2d52f4f19023101" => :el_capitan
    sha256 "0a34215dfcd908571ca6b65d3ca4d79c2758e3a4edbf4d3c8da944a8567fc02f" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "leptonica"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

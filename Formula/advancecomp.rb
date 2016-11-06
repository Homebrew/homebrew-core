class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "http://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/archive/v1.21.tar.gz"
  sha256 "58701a27a25061cd1a8c38c24b03a3166218a397b41c3249a10cde8b96564c6e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d0cfc85d5c61404a3298fa872698f80c284db509296c23719b15e517f81128bd" => :sierra
    sha256 "b920a8b98b6b79b0531d03b72180e6dde7664da504f4943bcb237703347de1bd" => :el_capitan
    sha256 "4c53c032983006823c7e119fd3f7516a9a9321bdd9d165a7ef0abaabc5b669cb" => :yosemite
    sha256 "119316cdf32ce8129a09e786a31bd6c21d3b153eadd6cd55e098f78b6f1ed884" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-bzip2", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"advdef", "--version"
    system bin/"advpng", "--version"
  end
end

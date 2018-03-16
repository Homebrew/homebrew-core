class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/releases/download/v1.9.2/htmldoc-1.9.2-source.tar.gz"
  sha256 "67998cce1208f3a677ccc5a8832ebafa8e48634857043f030b1025b3f03e53da"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 "25681fc471b90c60f0176f90eb11cd34e2d665bf292135fe096866fe3deb2e63" => :high_sierra
    sha256 "2a58462bf77d6c8f3563001290266a66b17928807bf7c711b635e349563aaac9" => :sierra
    sha256 "e16c2eb9efea592703f7cdcdc5c5fe2f5355c84bba6d72fcbc5f6d1bc7ee871a" => :el_capitan
  end

  depends_on "libpng"
  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end

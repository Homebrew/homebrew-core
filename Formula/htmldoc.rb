class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.8.tar.gz"
  sha256 "7f7d8964f4a0c18834740a33793bdf64316f6fac4b4645993072de590e71958d"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 "814f442925a4ea081877871d2b93ef30c604b36f31d032a9ba8812fb884e0935" => :catalina
    sha256 "affd04e2c20d1a1616d20a87a12e529fd8bec6a2a181d6b0dbee67c3605ca87d" => :mojave
    sha256 "e48bc31f04e676f2e6c13403de195cd09f7d43ea94ff1dd7b42d2d3b2990d1b0" => :high_sierra
  end

  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end

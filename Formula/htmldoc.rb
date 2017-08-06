class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/projects.php?Z1"
  url "https://github.com/michaelrsweet/htmldoc/releases/download/v1.9/htmldoc-1.9-source.tar.gz"
  sha256 "20ffc617f33e11aba7c726c32b23512c69fac0f6afb7fa8eec2c20b419fc0579"
  revision 1
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 "2d7de95746e4ac5e8a220a5207f31592e30900993c91394795028b8dfbdaac52" => :sierra
    sha256 "6570a8d07e4cf9b4f2bf5503814ba1153d32a819128db5a679c0b75a0c8aaf60" => :el_capitan
    sha256 "0c364daf5e5ad045c35f38e4024e80037f03193494c1d237016a8b24bec2d3a5" => :yosemite
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

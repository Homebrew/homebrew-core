class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/releases/download/v1.9.5/htmldoc-1.9.5-source.tar.gz"
  sha256 "0be1ae7986e01e94d482b3af7dcee19800117c8a61ef67426c30ae7744a79ea6"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 "f3b51bd3e85a38093908ab37219d10776fe295285dd7f94bb376ea6cca14153a" => :mojave
    sha256 "ebd8051ed1665fde7427941aab99352e3aa2d3874d3733ac2bf3b13756231417" => :high_sierra
    sha256 "9febf8082b8b70eb5f1864b20fd7d893df306c2cccf3af84341d22347f987d0d" => :sierra
    sha256 "a53860f24217691f3ae9ae565d8c4661d89869b45d95cc79efc12df567f3d297" => :el_capitan
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

class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.74/pstoedit-3.74.tar.gz"
  sha256 "353242fa4a3a73c3c856d1122a4d258a12be869707629603807e27137566990c"

  bottle do
    sha256 "9a2cea540decaf93a026ba2e246a78ffd6a6bd68bdc26702d913ce82fd73bd36" => :catalina
    sha256 "08a1be5ab3a0b2782a0c4df3c14639f1d7da4a0b66af6eed1147a249b4b7b41f" => :mojave
    sha256 "d8fae40ce28f534dc2c2b90cbd4a9db4ae002c69273b9cf64695c6f7cbe3e653" => :high_sierra
    sha256 "029b9f2869ebcbf06c8f3cffda92b5bdb44577c38100c39524f9bbd5d5b4ccbc" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "plotutils"

  def install
    ENV.cxx11

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "gs:pdfwrite", test_fixtures("test.ps"), "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end

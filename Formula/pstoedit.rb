class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.77/pstoedit-3.77.tar.gz"
  sha256 "9a6c6b02ea91e9f836448ccc5a614caa514a9ba17e94f1d6c0babc72a4395b09"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "dce054c832eec5e05bce925ce70277c877cb8ca623b6ce165de399d47f66836b"
    sha256 big_sur:       "eeae982fb21d7a8568f1ce4547fae20e363f6a3217da6ebb51ab57c4603137c6"
    sha256 catalina:      "68ec1bf2168f33a45cd4787b00d666e460115b99aee28b12a30199c1ce260d40"
    sha256 mojave:        "058c36cd7907d452cabd992a3dbfc71f87d8f2a87ae5a64aeed82418d4cb071e"
    sha256 x86_64_linux:  "700f92af568334b5eaed855fcc02840095e89459329dcee924568ea97cab02d4"
  end

  depends_on "pkg-config" => :build
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "plotutils"

  on_linux do
    depends_on "gcc"
  end

  # "You need a C++ compiler, e.g., g++ (newer than 6.0) to compile pstoedit."
  fails_with gcc: "5"

  def install
    ENV.cxx11 if OS.mac?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "gs:pdfwrite", test_fixtures("test.ps"), "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end

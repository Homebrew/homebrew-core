class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.78/pstoedit-3.78.tar.gz"
  sha256 "8cc28e34bc7f88d913780f8074e813dd5aaa0ac2056a6b36d4bf004a0e90d801"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "0f232079d87357a6a68542eb29625272b61826ab8d0e20620532751bfd080147"
    sha256 arm64_big_sur:  "93f094bcabc8c0d24377e8cf6e6567cdb3b40f4e8eed2eb38961b28c44f15346"
    sha256 monterey:       "3403d2caa0bba4718c2c7b26fc9e0449f9a962743d86e1db1d8b25023af1d21b"
    sha256 big_sur:        "d0e97ac142787f5b0c16c0138675c476f747403e4b94b6c12dad23c70e05d268"
    sha256 catalina:       "cdc3a9c75a626efd0562e786f08fd57dada5b764f9d39dec61c748eca707ccc9"
    sha256 x86_64_linux:   "9b5b7269382d2ed28060b51eb8ab82339127121675df1a73de76aabedcb088ff"
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

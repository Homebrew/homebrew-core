class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.75/pstoedit-3.75.tar.gz"
  sha256 "b7b5d8510b40a5b148f7751268712fcfd0c1ed2bb46f359f655b6fcdc53364cf"
  license "GPL-2.0"

  bottle do
    sha256 arm64_big_sur: "62d09abcd35a1d933545c501578d9583978eac45569bb7b3702f6fd1b5cbea9a"
    sha256 big_sur:       "1eb7bdc1ab76c8ae40450b686b1948f3e037ca871d7c505657489d501e073a5a"
    sha256 catalina:      "f048d902c088f0625c0c9e18d84b159493775b40e742812b040e7b517900260a"
    sha256 mojave:        "1f3ec91e58d95e08081694b43e031ed83f13a73cecff15c55c532268282b0ad1"
    sha256 high_sierra:   "22710dd8997d40cec3492c40960a9966b80b386bdbd3fed46515c66bb25053d7"
  end

  depends_on "pkg-config" => :build
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "plotutils"

  on_linux do
    depends_on "gcc" => :build
  end

  # "You need a C++ compiler, e.g., g++ (newer than 6.0) to compile pstoedit."
  fails_with gcc: "5"
  fails_with gcc: "6"

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

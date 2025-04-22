class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5.2/diff-pdf-0.5.2.tar.gz"
  sha256 "7d018f05e30050a2b49dee137f084584b43aec87c7f5ee9c3bbd14c333cbfd54"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "520ca811e168d7e466572c9da296ab1d67e32b839ff6cd6cc760b6a2d8e87feb"
    sha256 cellar: :any,                 arm64_sonoma:  "476dd932746a9fb40eace829b4fe1d06a9e47d5fa38ef7ac39c0d569b2c02c26"
    sha256 cellar: :any,                 arm64_ventura: "5119383788dce6966d1e63c972d63291bcebfffe9c04bfa2afc724d409b7bc9d"
    sha256 cellar: :any,                 sonoma:        "e084c03e61866407057108db22f32f5926d9ca67d8370f69621b5fccbb1b5b66"
    sha256 cellar: :any,                 ventura:       "aecba03f87da7b448e6f0ccaeb6fa73198cda2d426b903fa2b4c011a2212245b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fa81a93d5d39277cdda0a4def3ad9ad2b1f309ecc49bcd3bb14534362f6bc54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a33ef479a7e400ad5adc632acb18df3f2bd567d9cc1b8ebc9c5ef298f76a6b7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "poppler"
  depends_on "wxwidgets"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    testpdf = test_fixtures("test.pdf")
    system bin/"diff-pdf", "--output-diff=no_diff.pdf", testpdf, testpdf
    assert_path_exists testpath/"no_diff.pdf"
  end
end

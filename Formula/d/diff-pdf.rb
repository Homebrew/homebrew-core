class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5.1/diff-pdf-0.5.1.tar.gz"
  sha256 "017d52cb7ddabdbf63c6a47f39b2e5a1790022b95295b0d047817904e093245c"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ff732b24a31ffa9bdec843606dcbe169212f651544fad85faf35f17ce253dc87"
    sha256 cellar: :any,                 arm64_ventura:  "9fc1ea109410089a83a21c5770ea6cefbbe762959b0178d48d62e4e6bb508023"
    sha256 cellar: :any,                 arm64_monterey: "b7704e32dfe82cb80b0a578fe941ec061b57f4c15687688205ac4ae4a38f00da"
    sha256 cellar: :any,                 arm64_big_sur:  "5a608fdeff544f69792c006b8f037f5f8d7dc2d4d892dba6b32cd6bd74359fc8"
    sha256 cellar: :any,                 sonoma:         "304afd227b4e1ed352a8d11c0013b01bbf16d5a2a2f4a224cf794a53eeccfe21"
    sha256 cellar: :any,                 ventura:        "42d8c52bc1a90264e14765db5d8e88ef955e67d16e83c19d66a0fee413cb6687"
    sha256 cellar: :any,                 monterey:       "9dfa37086b2fe582102413702f8c6f32cc5f34e6ceb444701bdda93dca3358b4"
    sha256 cellar: :any,                 big_sur:        "14ff56d93303382cf6969c50bd772a0b142379ae3f0261441fa4fb8e8dff4095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0d010012f000f666a8e5f398333f8e5ea4f6db43a3f6cb8bebbca3c9c94e66f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxwidgets"

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    testpdf = test_fixtures("test.pdf")
    system "#{bin}/diff-pdf", "--output-diff=no_diff.pdf", testpdf, testpdf
    assert (testpath/"no_diff.pdf").file?
  end
end

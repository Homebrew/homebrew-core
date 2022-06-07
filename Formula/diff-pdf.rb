class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5/diff-pdf-0.5.tar.gz"
  sha256 "e7b8414ed68c838ddf6269d11abccdb1085d73aa08299c287a374d93041f172e"
  license "GPL-2.0-only"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6221f00c375eebe4d356c14dec2b7b28a8486636a10333c8ef99d0fb8c9f95b1"
    sha256 cellar: :any,                 arm64_big_sur:  "f6b1b97f6a30c4318e2c38526887bd4f6dc92dc3badef15e9af39df27819eb96"
    sha256 cellar: :any,                 monterey:       "acc8ff103fa29c4c2f42efc1010f5cfadc364b735a4b6b1750091502c69696be"
    sha256 cellar: :any,                 big_sur:        "07ca313f26653f86bc93318ef6c8c544331837ef46f592f95c4b436f29c9b4e9"
    sha256 cellar: :any,                 catalina:       "5623153835d7e0f13cd40f691b8a28d795e9157991c8ffef01b75ea7fc3c082b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37f48305aae394028a8a12f3e82b1e1b0a19771e8735c104e554875e0abde3e7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxwidgets"

  on_linux do
    depends_on "gcc"
  end

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

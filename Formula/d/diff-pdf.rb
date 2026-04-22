class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5.3/diff-pdf-0.5.3.tar.gz"
  sha256 "dc4004fe1199eebf381b5e0f2a60b6b59ff73434730e4f0aae1e0d02fa171b98"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a01e632da3e4503ad6263b32945640091e38519b0755fd7366ccebe6bad0c68"
    sha256 cellar: :any,                 arm64_sequoia: "47cfb2dd2bb8d255eeaf4e34f6837a072162fd62a9ff87efdde52a36c200a8a8"
    sha256 cellar: :any,                 arm64_sonoma:  "af4b9eb8bd59d7f5bfa80a4b19a58e55d172ecad11ba7f1f7b7cf294197d4cc0"
    sha256 cellar: :any,                 sonoma:        "7eb6849fe6ba6470939f031049d3e69bfb1b10e96157c5e281bad811af019ef0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6e83d1b6d78a2b87cc79c1e8dcec4f031d9fa8ecce2a7983312806fde32801d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed2a793df250161d395018d397133ee0c6608e4aaa88400079b5037648ba5c84"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "poppler"
  depends_on "wxwidgets@3.2"

  on_macos do
    depends_on "gettext"
  end

  def install
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    system "./configure", "--disable-silent-rules", "--with-wx-config=#{wx_config}", *std_configure_args
    system "make", "install"
  end

  test do
    testpdf = test_fixtures("test.pdf")
    system bin/"diff-pdf", "--output-diff=no_diff.pdf", testpdf, testpdf
    assert_path_exists testpath/"no_diff.pdf"
  end
end

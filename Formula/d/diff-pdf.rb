class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5.3/diff-pdf-0.5.3.tar.gz"
  sha256 "dc4004fe1199eebf381b5e0f2a60b6b59ff73434730e4f0aae1e0d02fa171b98"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b0f369e96595e1c71c820869b8c9e64878911d6a3d55b8e50dfee3e19b70cdbd"
    sha256 cellar: :any, arm64_tahoe:       "fc79a1e968f7019d2e632ae2c03055907ed3240412c052aa51c411523ae62a2c"
    sha256 cellar: :any, arm64_sequoia:     "94800b9fe7649ca7ba806692ca49cb749e8054653849f44ddd81baa9448e6f17"
    sha256 cellar: :any, arm64_linux:       "8b395bf48d6e1adf3a62cb9050fe33e24b7b375cecb891ab165c732d775ccdac"
    sha256 cellar: :any, x86_64_linux:      "15b8ff225c5839e99cfa1e878302002608412b78e9cde441638b26e8e3057dff"
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

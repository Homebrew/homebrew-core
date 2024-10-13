class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5.2/diff-pdf-0.5.2.tar.gz"
  sha256 "7d018f05e30050a2b49dee137f084584b43aec87c7f5ee9c3bbd14c333cbfd54"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "53f6848c95819dd903f468dc4072a91a098c1639fee29b033c8a87dedf841ea8"
    sha256 cellar: :any,                 arm64_sonoma:   "aeebc69df89c64b855b491899951b9b19e9736924c7ffe824237cea86dd4301a"
    sha256 cellar: :any,                 arm64_ventura:  "5a9824bb9190b9bdc41c27dc0b435cddbd3ee6b31c74280c36513eb413b7fd1b"
    sha256 cellar: :any,                 arm64_monterey: "29339f3026c7bc502a35b2247ef1309d69e74b0efca3f08ce168d31c497f5c80"
    sha256 cellar: :any,                 sonoma:         "3451aa9d8016f0a6daa510cc908a0b95a336bf84d40f705fae50217810eebfec"
    sha256 cellar: :any,                 ventura:        "dafb53f35f10213fd9b6d09f96d3f3250ed0540cdbf2e64c429cfe78f98afe1f"
    sha256 cellar: :any,                 monterey:       "4685df342153b5f2653257e5e27f7c4af00c2d5e8dad798e63e34c0308e6a347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c78b9ef3dd41acc7212514933be8b34cba6eb56ca3044444db481d87eba71eaf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "poppler"
  depends_on "wxwidgets"

  on_macos do
    depends_on "gettext"
  end

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    testpdf = test_fixtures("test.pdf")
    system bin/"diff-pdf", "--output-diff=no_diff.pdf", testpdf, testpdf
    assert_predicate testpath/"no_diff.pdf", :exist?
  end
end

class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5.2/diff-pdf-0.5.2.tar.gz"
  sha256 "7d018f05e30050a2b49dee137f084584b43aec87c7f5ee9c3bbd14c333cbfd54"
  license "GPL-2.0-only"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39d3ffa2ca4a7c23b19d569d3ad80308cb2a427ee9386024770f27ee48bfe1ef"
    sha256 cellar: :any,                 arm64_sequoia: "a6fdb5286aa134dcdc600dbabf9c84c5f8f9c1efc83ea73311bb7bb2a0840739"
    sha256 cellar: :any,                 arm64_sonoma:  "8170798a716f04ea3a50de00147750f2b04464ef614fb465a9cbcd337ebd60a1"
    sha256 cellar: :any,                 arm64_ventura: "b5c66a318b2c7b71dcbe2366b8ebda2950d0652568af574d859c758f29e72ba1"
    sha256 cellar: :any,                 sonoma:        "5edf62102c1b6662823fc3a6c897b9c94c837251d3d969e69f573daf3129b864"
    sha256 cellar: :any,                 ventura:       "2eaf870131f8fabc96a894893d02f23302ee681dfa1f482ab30c0e129b181ffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ed5d51b2b1950bacc69831b82141f87a1d34ff9cf7344b1dba6c7f2f472de8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ce93415222a7df01057095309882ee6b32a02f5fc5d175bc8779567ebd76b7b"
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

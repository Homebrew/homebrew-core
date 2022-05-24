class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.13/lcms2-2.13.1.tar.gz"
  sha256 "d473e796e7b27c5af01bd6d1552d42b45b43457e7182ce9903f38bb748203b88"
  license "MIT"
  version_scheme 1

  # The Little CMS website has been redesigned and there's no longer a
  # "Download" page we can check for releases. As of writing this, checking the
  # "Releases" blog posts seems to be our best option and we just have to hope
  # that the post URLs, headings, etc. maintain a consistent format.
  livecheck do
    url "https://www.littlecms.com/categories/releases/"
    regex(/Little\s*CMS\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0fc9bdf0e245b210e0260f2a641dc88b1b1b5c1004eeadaafb9536eb21a347ab"
    sha256 cellar: :any,                 arm64_big_sur:  "e78f36abce8a417db16755c5dbbdf8817e14861ea92bd029bb36e424a8563f52"
    sha256 cellar: :any,                 monterey:       "0c50589e60d1fdc8e8ae52550c1ed0e9bbc68f77d105fa0180192d517cc5a85a"
    sha256 cellar: :any,                 big_sur:        "7fbbf54484b962a2b72104db3f425587acf88666c0dd0753b00eb104bce1a2cc"
    sha256 cellar: :any,                 catalina:       "152469fd79f4dde476f916be31fe0657656f298512201e6eb8be9f8dd9016c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "021649a443c169b8b18dd404f99d367ef79e5a6f650d8912b552a1b887e85ffe"
  end

  depends_on "jpeg"
  depends_on "libtiff"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end

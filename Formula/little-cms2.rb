class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.12/lcms2-2.12.tar.gz"
  sha256 "18663985e864100455ac3e507625c438c3710354d85e5cbb7cd4043e11fe10f5"
  license "MIT"
  version_scheme 1

  # The Little CMS website has been redesigned and there's no longer a
  # "Download" page we can check for releases. As of writing this, checking the
  # "Releases" blog posts seems to be our best option and we just have to hope
  # that the post URLs, headings, etc. maintain a consistent format.
  livecheck do
    url "https://www.littlecms.com/categories/releases/"
    regex(%r{href=.*lcms2[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "249a7b998b64074fa0978aa52cdbb9d11414734b2b5c2061ebc61159a9f98771"
    sha256 cellar: :any, big_sur:       "e6f70f21087ef1f0e1379446b5b5f460915d3a132763919feb245534ed9bc4af"
    sha256 cellar: :any, catalina:      "b0fe7486871b0fb0e34012f48bce09e96229e5e2985d64e7a0164c2847e41975"
    sha256 cellar: :any, mojave:        "e05f0a487d2243411eeb9fd9909f875517d7b27feb3cb914117acd9c60b76fcc"
    sha256 cellar: :any, high_sierra:   "928d1b8b8292a2d7950d0ef1381c70996bcde325f0124d7dcb68059090544dac"
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

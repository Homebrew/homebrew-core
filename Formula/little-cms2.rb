class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.13/lcms2-2.13.1.tar.gz"
  sha256 "d473e796e7b27c5af01bd6d1552d42b45b43457e7182ce9903f38bb748203b88"
  license "MIT"
  revision 1
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
    sha256 cellar: :any,                 arm64_monterey: "fdad36e27253dd1615d5b9be2703b378336b908122b68fd4652d032e127caf76"
    sha256 cellar: :any,                 arm64_big_sur:  "a27e31e124ebda72e24cb0cacff0cf74e5bbf96e31696288498d8e538deaff36"
    sha256 cellar: :any,                 monterey:       "229315ae3a56e41cd107b5193d76aab56b5e69cdc04d0e5cbad38e05527314da"
    sha256 cellar: :any,                 big_sur:        "c279aafb33937527f437354cf05e9d5028bc1d47de0991bb4ab0c0f87c5df0e4"
    sha256 cellar: :any,                 catalina:       "a1cb1529b75523fd613c44c893ca283847b5e9fbed2f77ede3b7c17317bf46e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6055cc008296335ab999e1d0d48180bb8d539c266e890596ed13c1f21e850532"
  end

  depends_on "jpeg-turbo"
  depends_on "libtiff"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end

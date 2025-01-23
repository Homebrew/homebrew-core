class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.16/lcms2-2.16.tar.gz"
  sha256 "d873d34ad8b9b4cea010631f1a6228d2087475e4dc5e763eb81acc23d9d45a51"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ca8251ccf62b685661dbec30548774e27c9d0fbcd5fc656993b2689a09ac5eb2"
    sha256 cellar: :any,                 arm64_sonoma:  "b607bb445fb9a11ee2fb8ff80748d6213adb5819cf0f2c680bf075cd2f192632"
    sha256 cellar: :any,                 arm64_ventura: "4b0f277b9e10759f8987455ffba6c9bd6223bdd78d91581e5f42e2cac64ac268"
    sha256 cellar: :any,                 sonoma:        "39b4f4d4508587316f9e65a69146de2f79d562fe33993819527c666cd636e732"
    sha256 cellar: :any,                 ventura:       "c125594c81f2ed6d880c471eed83efe94e92bf7975515b4814441b90c8847a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54d4aa2b4c4801a8bc575661e5db6c676bf7acb531a6fd0bba49b15366231546"
  end

  depends_on "jpeg-turbo"
  depends_on "libtiff"

  def install
    system "./configure", *std_configure_args
    system "make", "install"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/lcms2.pc", prefix, opt_prefix
  end

  test do
    system bin/"jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end

class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.19.1/lcms2-2.19.1.tar.gz"
  sha256 "bfc54f7bab59fbc921012014a8032e4cba4abd46db47d46b76416a8c0b2815c8"
  license "MIT"
  version_scheme 1
  compatibility_version 1

  # The Little CMS website has been redesigned and there's no longer a
  # "Download" page we can check for releases. As of writing this, checking the
  # "Releases" blog posts seems to be our best option and we just have to hope
  # that the post URLs, headings, etc. maintain a consistent format.
  livecheck do
    url "https://www.littlecms.com/categories/releases/"
    regex(/Little\s*CMS\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bdd144e98ee16fa60a99ec45048aa06e24cc95bd16e059952f693c4c4f8f7725"
    sha256 cellar: :any, arm64_sequoia: "d70483a699a4b0aca8000d6affd41b2fda320c0c9388bf5bf46e7b3e3472229f"
    sha256 cellar: :any, arm64_sonoma:  "6657dccb4ec6c9a6d99255fdc226299c883b75d1a9cfe9b1650720721c1af626"
    sha256 cellar: :any, sonoma:        "b6a008c02dff9c51ddee68a8a4cbf2b031f9ab2e6c8554d92ffbbf982a31f1ed"
    sha256 cellar: :any, arm64_linux:   "802e142d3004bc1451352d750bfa4c932738996f89d8c0dfae67b4bd2098f985"
    sha256 cellar: :any, x86_64_linux:  "b0b1fb427dab5505c1eb4867f2685a523c36e907b9f26ccd16e810c8fa1f427c"
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
    assert_path_exists testpath/"out.jpg"
  end
end

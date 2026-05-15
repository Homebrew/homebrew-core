class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.19/lcms2-2.19.tar.gz"
  sha256 "49e7e134e4299733dd0eda434fa468997a28ab3d33fa397c642b03644f552216"
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
    sha256 cellar: :any,                 arm64_tahoe:   "09a863e549255993de3f73d705328b1202417dff324edd30c703b77fcee09b01"
    sha256 cellar: :any,                 arm64_sequoia: "be9135a585a60f84ec283d97e7a89bec9338e525679b637b171092338c5c28a0"
    sha256 cellar: :any,                 arm64_sonoma:  "27689360239a2d3e1b69f14d2f981852c7cacc3bbd1fbdfba499a059cf69b551"
    sha256 cellar: :any,                 sonoma:        "213896d19f9b7a0baad9c5a0b5daebe4f3d901a93c85de24f299c01ab1dadede"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6db1e7a93012fc49569cedc5772f9a2cab3ed4411c7f1015652b3b5d132740b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8df57239d5b52a119832c5b042c5a9fda56caf1692ac1377d517cb6bfc578ed8"
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

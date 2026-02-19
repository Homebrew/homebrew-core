class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.18/lcms2-2.18.tar.gz"
  sha256 "ee67be3566f459362c1ee094fde2c159d33fa0390aa4ed5f5af676f9e5004347"
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
    sha256 cellar: :any,                 arm64_tahoe:   "ea51fe72839acbeb85a14cbc5f758fcfd6c10704bf301511b67b80d1eb437e25"
    sha256 cellar: :any,                 arm64_sequoia: "ef0bc9dde8d758c481c8ef9f7ac032776f0c67de87b2bc453e0bdbb037914cba"
    sha256 cellar: :any,                 arm64_sonoma:  "a3b6b7e04b11587086a64a17b6c8880cf20bab9d92d00cad8f6d71cc0d347289"
    sha256 cellar: :any,                 sonoma:        "b4c863e6eb564449490359a59c6fbfa8b72e305f6f81bb81c17eb24c21388a19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58e39623413e57b7ae9a3a34aad0aebce5564264f3af4b3388570860d04b54be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f004716c38223986c27a7f6b545f169616d6ee060d3b652b5f936a28d9725ae6"
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

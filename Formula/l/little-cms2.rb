class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.17/lcms2-2.17.tar.gz"
  sha256 "d11af569e42a1baa1650d20ad61d12e41af4fead4aa7964a01f93b08b53ab074"
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
    sha256 cellar: :any,                 arm64_tahoe:   "ce5a0c917ab8273866eb04f88af435f8590fe461fe0b2c4b48c2859a4b668e7a"
    sha256 cellar: :any,                 arm64_sequoia: "3827b5a8583f0e92987bd0e7c721bda834157ad366d2cb66596559dd8654c9ac"
    sha256 cellar: :any,                 arm64_sonoma:  "aeb24e3f0d025808da8a3c0d9c4e42b0aa58a3dbc51813baf90940fcddf20be9"
    sha256 cellar: :any,                 arm64_ventura: "a4edffc61a638164f92c20dbb084eb00a82ce81cb2e58aa18ad5f1d73c843c5e"
    sha256 cellar: :any,                 sonoma:        "6f3a75284dcdd815c90822ac2d7ca5da326f9b1caa429b57bc95bc1f49d76881"
    sha256 cellar: :any,                 ventura:       "0d73b47c0c2bc4974127934587472e9a6a7dc1c54ef6eaa409f64c99568c2edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ec5e7088ce3f220f3607200e7e9fb111359569de78eaf4c2ac2b7f5dbb9d9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "667006576a5da32e7984c0c310cba11d63970e9f4f501200ef949ab9b0559709"
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

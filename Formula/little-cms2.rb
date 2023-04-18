class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.14/lcms2-2.14.tar.gz"
  sha256 "28474ea6f6591c4d4cee972123587001a4e6e353412a41b3e9e82219818d5740"
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
    sha256 cellar: :any,                 arm64_ventura:  "f65e0095a8a82a803ac26c5bbd5197032b8e744cc6f6361d992ee40d68174f1e"
    sha256 cellar: :any,                 arm64_monterey: "ae03cf730b8472ba74ccf339e64c2275b3b1558bee4d43f87d13bb8ddf15bcfc"
    sha256 cellar: :any,                 arm64_big_sur:  "84b9a2b8c35fed041f23b907506aae85e501472ef55f7ef114756eb1d06524f9"
    sha256 cellar: :any,                 ventura:        "1a90d971326c5f82f14d2b758d6bd7d8c28ebe513eac39b12a96e5df57ce12e0"
    sha256 cellar: :any,                 monterey:       "57a938e19b097c8b0b7da9e8969678ec5f76c6332ad0f5122dce4a5558a93817"
    sha256 cellar: :any,                 big_sur:        "53fb3147f52eca75b7954795c521e3ca40aaccd542cfaae7befc3a1d143b3cc8"
    sha256 cellar: :any,                 catalina:       "2c3da48dad601fc033cd0d2ac8235ea6b958643ffc9bc95260bf2b356c9af668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d9004057cd982330e2817ba715615660c07ef4bedb0282d82b96eb633b0ab4"
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

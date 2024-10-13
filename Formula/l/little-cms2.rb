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
    sha256 cellar: :any,                 arm64_sequoia:  "cbd8af49cc4b8454636a2cdcfae87b7005f11cbb7466994f0bf419968f33ea5d"
    sha256 cellar: :any,                 arm64_sonoma:   "d1ed5796de3f00d4b1301e9062cb54b2337c8e8dcf2ae9be8e03f3ed7af791e0"
    sha256 cellar: :any,                 arm64_ventura:  "c7eee75a83a2be3f19aa53ad043da4a316af7bc7f57e6aaf8f311f9e6e354be8"
    sha256 cellar: :any,                 arm64_monterey: "2f155dd797f8d008616c61677d7b7ebc49b349feb06a1c86239d49e1b9a5118d"
    sha256 cellar: :any,                 sonoma:         "46dd0d6ba9293999feaeb701a4c614440250a51daf0949478fbd486650a637bc"
    sha256 cellar: :any,                 ventura:        "1c2e7ed787c6ff05b52bf3d1f6e27047e390f609af8a2dcfbb5904cdee8a0fff"
    sha256 cellar: :any,                 monterey:       "c3add26aa2b85ad6bda455cb9ad2f14a3e0055f458722757162dcfe91a992044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79268ac2afeaaa7bce8af516f329f808443c3bbad64e705f8a39e4f0ccc112e2"
  end

  depends_on "jpeg-turbo"
  depends_on "libtiff"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end

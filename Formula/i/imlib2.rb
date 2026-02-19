class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.12.6/imlib2-1.12.6.tar.gz"
  sha256 "59743ce82aefa9c1ec9476af608d541b74164714d2928fbd84ff5db6c4399079"
  license "Imlib2"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "2b91eb5c5e4b335cb4ce21ac5f9379e37c1d798a99605db3edb384a9b92f2e6a"
    sha256 arm64_sequoia: "622ef7a95f9b20ea7521c35c7e6608ca8c69cda18f838c2bbbc35c5899c03c84"
    sha256 arm64_sonoma:  "c12ac5662371d80fc850fa03086044ea09dec1812afee6a4febc6f52fe20a082"
    sha256 sonoma:        "a5894661719aa0e61993021bcf5683adb5c101098872bc6e4ddcae528752425a"
    sha256 arm64_linux:   "3f6ba4191ffc83dafc78761ac21ff667f455caf1a8a88c718510f0ba51332e53"
    sha256 x86_64_linux:  "d86ce123067142a835df423eea2c8a2d4cb1d095ab44688c315a00297d7d6c2d"
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-amd64=no",
                          "--without-heif",
                          "--without-id3",
                          "--without-j2k",
                          "--without-jxl",
                          "--without-ps",
                          "--without-svg",
                          "--without-webp",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end

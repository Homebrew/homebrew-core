class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.12.5/imlib2-1.12.5.tar.gz"
  sha256 "097d40aee4cf4a349187615b796b37db1652fcc84bb0e8d5c0b380ab651d9095"
  license "Imlib2"

  bottle do
    sha256 arm64_tahoe:   "a35840444372c0c5b77383aeb5543a62ef74b2368e3b6a28cd733ef2f3204ed1"
    sha256 arm64_sequoia: "45e7832774c28fd6a40124c51835018534047536a506a8d7eed221ea2ab0204c"
    sha256 arm64_sonoma:  "baf76382fc4937739ed8d2b61486b21a6677014362e0f3d891e6300d2a3f0012"
    sha256 arm64_ventura: "deea7061495882c1a753838d12b5c84aeafad29a6422320bdae76c73bc5a29c2"
    sha256 sonoma:        "9eba1823dbefdeebc3529ab8b40fd9a94ae36418e127f6743ccde0cd8ba6f78c"
    sha256 ventura:       "9370ff5272a65cf7cf2f6748085c5728f6ac53cf1c42a382c4ef868e6856e8b8"
    sha256 arm64_linux:   "2779490f04716e717c042160e6a70288b7de6097b42d2f5c573d8b3415abf482"
    sha256 x86_64_linux:  "4a735d4a3638e58916205c67984e5ee5fa1b2aff554c9da6310d57995c84234f"
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
  uses_from_macos "zlib"

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

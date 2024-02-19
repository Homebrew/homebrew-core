class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.12.2/imlib2-1.12.2.tar.gz"
  sha256 "e96b43014ac9d61a0775e28a46cf7befbd49654705df845001e849e44839481b"
  license "Imlib2"

  bottle do
    sha256 arm64_sonoma:   "49863bb2c0e0d556387263cfe4641f989231e0fe977b32a840aa458b8eb1355b"
    sha256 arm64_ventura:  "350dbe94e18abd0d1112111f0ffe15759f97a9b6d1504ec59e1d6dec8584da32"
    sha256 arm64_monterey: "e8d0ced478e0df52afc58717551f4a8fbae48cb1680b0ab7b953311f71220b46"
    sha256 sonoma:         "21c7aa79788ebd672c9c0a8ddef17d0fd63c0ff435028af8136639c61ba44754"
    sha256 ventura:        "3a0de7fb20f2d7dc540890183fa9a6018ca4b694dcccf693e91ceaa8c157d821"
    sha256 monterey:       "947035eeb12819786c1bab983e6e726235f6613bf26e319e77593b53b58610d1"
    sha256 x86_64_linux:   "404fe21bc298401f8d8205cbaa470d575a5e092bdfaaa31dc2824d262a197e0d"
  end

  depends_on "pkg-config" => :build
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
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-amd64=no",
                          "--without-heif",
                          "--without-id3",
                          "--without-j2k",
                          "--without-jxl",
                          "--without-ps",
                          "--without-svg",
                          "--without-webp"
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end

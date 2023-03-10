class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.11.0/imlib2-1.11.0.tar.gz"
  sha256 "94b74f7c28d5d05ac936d479f944a71222311b8ced8d012fd57010830faade31"
  license "Imlib2"

  bottle do
    sha256 arm64_ventura:  "b873e44f7f8af7fd5495e77713acdc1873f187e13f5a1636c32d8a87a16cfb2e"
    sha256 arm64_monterey: "622b01363a9a6725654a482b463d0f6ae5b2b13b643ee90e8efa4e5e4e0f41e5"
    sha256 arm64_big_sur:  "f5ffc27c58c52ce4b49b803ba9938b3d71b17dc1aebadfb45ced220a22e20219"
    sha256 ventura:        "3d204b875066b60575d05d2d2c0596c60acf7b49e1204bf19aa90f2ad15b6e4e"
    sha256 monterey:       "ebee85e06daeb7052b5da9825f0a0cd7daed59ec978a88290b3829d3d99dfdf9"
    sha256 big_sur:        "0372b4f085ac6492d55aba0f82311bcc96baa07018ba61e3b6b69f054264d4b5"
    sha256 x86_64_linux:   "e0866bc153e38b192a6415a55bd08b8289a85b0db2476ba051e6b43d33188dfe"
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

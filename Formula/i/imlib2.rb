class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.12.0/imlib2-1.12.0.tar.gz"
  sha256 "b139dca28d8de24fa50475851fdf59d3439f00e8b42e8c0f8daebb55a102455d"
  license "Imlib2"

  bottle do
    sha256 arm64_ventura:  "886bd312d78665ae7efda3afd62415a880ca2cf89755eca3e287dce773d4e12d"
    sha256 arm64_monterey: "07daa7529afd7fc4414aa52dbd3c9d103ceada3eadb946be19a49f94617a7735"
    sha256 arm64_big_sur:  "22967bf1ff05795915545d2c345965d565a7a33c1150ed6dbbd4f01baf804d9b"
    sha256 ventura:        "9c996088bc94faf3fc0207b0b4ca8a6a7cd95f48df8161012c6c683f3a445294"
    sha256 monterey:       "8c390ebf592b6999d47b57d043f525f252f27f0412410f3c4b106aa22c44996a"
    sha256 big_sur:        "a78ea6aaf666532f3126da56baaca0084427a3796435f877e694b59cfd378b3a"
    sha256 x86_64_linux:   "a4a6f6a70485b78567c91eaf019c5d519e7364cf63566ab5d781958081b42b50"
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

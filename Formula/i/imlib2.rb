class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.12.6/imlib2-1.12.6.tar.gz"
  sha256 "59743ce82aefa9c1ec9476af608d541b74164714d2928fbd84ff5db6c4399079"
  license "Imlib2"

  bottle do
    sha256 arm64_tahoe:   "e40db3a3b80f92ccdd0876eba2a05ae32080e95b955be72b84c8c6e6bcfd9f40"
    sha256 arm64_sequoia: "b49f99584b618e861037a083d758a21ccaefe19bb4c3f6b05244c43565025377"
    sha256 arm64_sonoma:  "e8abba966d2b714214c4e49cc9bcccc8551777575399399997af5b1d94355f82"
    sha256 sonoma:        "01c2d3f2744a1b4dcce172c3b8a4dd20d3a5f95ddf021ca700120500a1956b17"
    sha256 arm64_linux:   "e3aaeef9594fa1e0d4457ed0b23b43475cda697c302c87e4fc94cb618f2570a2"
    sha256 x86_64_linux:  "eca35ac2d3dce812ba7383117249ae7edfe17455f16388b045a0e96d6f7fde39"
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

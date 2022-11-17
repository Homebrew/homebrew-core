class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.9.1/imlib2-1.9.1.tar.gz"
  sha256 "c319292f5bcab33b91bffaa6f7b0842f9e2d1b90df6c9a2a39db4f24d538b35b"
  license "Imlib2"
  revision 1

  bottle do
    sha256 arm64_ventura:  "3a25df0d49729fdd193651eb7e2d49c5e80a9448a0dd45f07a81e6277d9ca012"
    sha256 arm64_monterey: "fdffbc8d14792e55d584bfa1890fb7e68e3d53eecde44ae717cfa174122f106c"
    sha256 arm64_big_sur:  "f84157bd9b0b3c03c8db03deea338a66fc357192c37086bbb5658582e3460b9b"
    sha256 ventura:        "34784d5fc92936586337607a431fbfb30229edc3a227661069371921c14667d1"
    sha256 monterey:       "2a8601b4da19db554cbc132908424a30ac56c18c86ea29579ae5aac7237ed1eb"
    sha256 big_sur:        "f5cb92557841c1e7c608f234c54d10c74d86d453cb3e91545e1b439332355f9e"
    sha256 catalina:       "627651e50914815a562ed3da631962487a1dae6f186b7a2fcdd8271da284fbd5"
    sha256 x86_64_linux:   "5102732236b65233ef115fec26e4035d96df41ce75722c611edf330266d7040a"
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

  def install
    system "./configure", *std_configure_args, "--enable-amd64=no", "--without-id3"
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end

class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.9.1/imlib2-1.9.1.tar.gz"
  sha256 "c319292f5bcab33b91bffaa6f7b0842f9e2d1b90df6c9a2a39db4f24d538b35b"
  license "Imlib2"
  revision 1

  bottle do
    sha256 arm64_monterey: "296de1a8aa74eaca3f8f7eba32d8d34152aa02f56cb30c36c5008c9076aef3fe"
    sha256 arm64_big_sur:  "153b96c3fc1fe5e69e9cb473b9e5b8561dab9d84b33291fce1bb4cd1ba794cd8"
    sha256 monterey:       "1cdde4e46948424b4cfc8d9913ed43f28245e72fb3f507ea2aaac9d2f3b37d43"
    sha256 big_sur:        "9b86cac71be3a227b3ae6b54ff7818a304bce206c20a5d7d4ea1a397ce635255"
    sha256 catalina:       "b81a47752d753827da8ef5f67257a1fbd8a87047ebba869b4d22dc420a4fd06e"
    sha256 x86_64_linux:   "d39b5dce347d1b8bdfb1bf0384b1d37fc4f393bac3cdb6ce722e448319764ec8"
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

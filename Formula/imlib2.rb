class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.11.1/imlib2-1.11.1.tar.gz"
  sha256 "4dd94e1f189287fa87e802b765cfc836153687b994412645757d56c139998b7a"
  license "Imlib2"

  bottle do
    sha256 arm64_ventura:  "e5c0a22aac902151e443e4026fea991060c928ed4c8b43571a5e275faab75e9a"
    sha256 arm64_monterey: "8882c7c06d2a19fad0cd5e2eab0f5f6b82b0e26962059e3d15a2f5b2e25dc1c4"
    sha256 arm64_big_sur:  "487475bed7b9fd659a9a359b8ee6259b7c8566500ff72e1bebdee2a10a08619e"
    sha256 ventura:        "3b6f18c68aa898362c0369af74006b79fc448068ba17b642c234d6e6895f44d1"
    sha256 monterey:       "79c6fcceb1ed4b3d038b8e8161650ac078c8b52422c2a4e7b1c82db4a7b83aa0"
    sha256 big_sur:        "e0d432a7a3990e40cf288d9322c6f94bee34f5b068fa7c8d96820cd00356cecd"
    sha256 x86_64_linux:   "c8cd99451da5eba77e97ab71e5fbcfee9a9f10183205168ad02ab57021a95be5"
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

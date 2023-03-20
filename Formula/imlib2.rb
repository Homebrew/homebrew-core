class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.11.0/imlib2-1.11.0.tar.gz"
  sha256 "94b74f7c28d5d05ac936d479f944a71222311b8ced8d012fd57010830faade31"
  license "Imlib2"

  bottle do
    sha256 arm64_ventura:  "9593d7f05cf0e259f616c5c40ed62646f4d14e3bfb7e68e77524ad3f6d97f70c"
    sha256 arm64_monterey: "924df5623cd34a98e1144f60d15f85f62524de314906bd357e1037eaed8bcaf8"
    sha256 arm64_big_sur:  "4d777d6f7b7625f852cec2639ba2ea353abeed0a2a2b74663d7abe5262e33272"
    sha256 ventura:        "f39e7d0faad74d47aa84419e0b87abd406343c5d30c3e677fd3375a511886044"
    sha256 monterey:       "773dbe255a23e3748e4ccc91b37a8c02447a9759bc5a5bfb6d2724ca166ca6a6"
    sha256 big_sur:        "46852d65700e5cf71b68ab45444dba8b0d7e791f6645bdbcaa9d15770d266a7e"
    sha256 x86_64_linux:   "ce52a8970e87f07be1a03d94a5dae4490ae912c51cbee7e312d030e2700d520f"
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

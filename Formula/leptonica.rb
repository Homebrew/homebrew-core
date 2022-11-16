class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "http://www.leptonica.org/source/leptonica-1.82.0.tar.gz"
  sha256 "155302ee914668c27b6fe3ca9ff2da63b245f6d62f3061c8f27563774b8ae2d6"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "http://www.leptonica.org/download.html"
    regex(/href=.*?leptonica[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b777db0134c92c82863e85a8e9241ea0f36a8d9c31b5ff422f27939a2529287f"
    sha256 cellar: :any,                 arm64_monterey: "f12078d1dd4aaeaad14a7f83e3fc80531b44c5468db5e4de2ac7e7e15c05b2ae"
    sha256 cellar: :any,                 arm64_big_sur:  "7149a71af47d2c56ee6d42b3bfbbd3e1acd028b5d88c06fd12ba9f53b8bce25d"
    sha256 cellar: :any,                 ventura:        "571adf341904b5146c02344885a6dd557b3124ea4c75f7eb1fdfa66b295c7a43"
    sha256 cellar: :any,                 monterey:       "d38cfdaa7ef6c06742a68619a4a6ff1832693fc5a3fc17326e5ada7562a64232"
    sha256 cellar: :any,                 big_sur:        "7f3cf712964bbdfdda8f2bb6ce5c6b72c2e60155fc0ed3e61f1b67b2a168dfd6"
    sha256 cellar: :any,                 catalina:       "fc3413c1bdc6e0fa60fa3b1a0c1cc5106f5c963f3f9322171f9ae5fd87a15a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe46f8ffbba3c0447d13174be795b0052510b7000a1aeee5b237f585334365c1"
  end

  depends_on "pkg-config" => :build
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "webp"

  def install
    system "./configure", *std_configure_args,
                          "--with-libwebp",
                          "--with-libopenjpeg"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <leptonica/allheaders.h>

      int main(int argc, char **argv) {
          fprintf(stdout, "%d.%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION, LIBLEPT_PATCH_VERSION);
          return 0;
      }
    EOS

    flags = ["-I#{include}/leptonica"] + ENV.cflags.to_s.split
    system ENV.cxx, "test.cpp", *flags
    assert_equal version.to_s, `./a.out`
  end
end

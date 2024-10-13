class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.84.1/leptonica-1.84.1.tar.gz"
  sha256 "2b3e1254b1cca381e77c819b59ca99774ff43530209b9aeb511e1d46588a64f6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d409e5b337a61e1e19fdcfcafa40db50513e78823e77b8d7c03012674bd158e4"
    sha256 cellar: :any,                 arm64_sonoma:   "67fe34fb9fbd1191142dc8415dc1c3bacc7a8cb427dc3d769f6c5d8b1351cbe7"
    sha256 cellar: :any,                 arm64_ventura:  "a508e5748000d9138113716f804876ea02a0ff09edb1b3f440805318abb3892f"
    sha256 cellar: :any,                 arm64_monterey: "1b2eeef988742aeb3b35faba109d737a8358000d16c0127ade00a72f74bdf708"
    sha256 cellar: :any,                 sonoma:         "532d63772dc6bf06389ba4eb7f970741144edc9f2933294c7aaa6a371c8ced3e"
    sha256 cellar: :any,                 ventura:        "de79973f211c5c6734ccb43e9d9f1e83bdf6040d3d9311a6483e8668b76e2314"
    sha256 cellar: :any,                 monterey:       "367222ae46ffb4758c4561d59c73ccf8f6f50fdfaf8ceb57fc44d7f9d80ce18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d192aba393509e4fad013b13143cd5fc426256ca72636fe69940aa2efa290f8"
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

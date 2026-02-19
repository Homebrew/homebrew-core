class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.87.0/leptonica-1.87.0.tar.gz"
  sha256 "c73363397f96eb1295602bf44d708a994ad42046c791bf03ea0505d829bdb6a7"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6932bf1645434e6c93d7bd4ca86623c55bdbd6d386833ebbdae969c581d4d303"
    sha256 cellar: :any,                 arm64_sequoia: "305a35821bb0d618e614c791e7fcd9e58e92b08d5763b4b4e1dbdcf69619d034"
    sha256 cellar: :any,                 arm64_sonoma:  "bc58db017510f010f5feccc1e88aaaf3ca118dc6750ad9ecef6cbb47e0358539"
    sha256 cellar: :any,                 sonoma:        "81d9615212f99786dbd3bee606c2963c4119defd7f782177e3096d750ad1ac41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf296913a82a15ba49f6ca5e11e4705bf783d278917772d5999c3a39b51601e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46b90af8964b6c265f258a8a7ec159a4881e9ec5c2d3d0e37cd91054b5e87999"
  end

  depends_on "pkgconf" => :build
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "webp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--with-libwebp", "--with-libopenjpeg", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <leptonica/allheaders.h>

      int main(int argc, char **argv) {
          fprintf(stdout, "%d.%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION, LIBLEPT_PATCH_VERSION);
          return 0;
      }
    CPP

    flags = ["-I#{include}/leptonica"] + ENV.cflags.to_s.split
    system ENV.cxx, "test.cpp", *flags
    assert_equal version.to_s, shell_output("./a.out")
  end
end

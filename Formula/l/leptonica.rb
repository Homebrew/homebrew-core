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
    sha256 cellar: :any,                 arm64_tahoe:   "ab32f1b8d1615316af71452ecb542668b6dc53b423389d87b15379f3a1640e27"
    sha256 cellar: :any,                 arm64_sequoia: "ea09ebafbd5411252013d28e0814c832a707858791d8cc71b6cb0acaf6cd5b55"
    sha256 cellar: :any,                 arm64_sonoma:  "4a62d0d40a8e5c0c38e814e39074371b56f19904d81c77800963d4da4f33f0e8"
    sha256 cellar: :any,                 sonoma:        "95455f7ef798c9bf0f11eb0fde88da376784bab6bcd2e184cd2f09bb8201bb71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95b1abbce20ad2492f2d26c50140da14d15d06c42af9857a6fdb69e6b9cd25e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc17c54a9ba3ff16d5bf508ff236ca5a87c70b227af0e1fe7873581b40591edb"
  end

  depends_on "pkgconf" => :build
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "webp"

  uses_from_macos "zlib"

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

class Qoi < Formula
  desc "Quite OK Image format for fast, lossless image compression"
  homepage "https://qoiformat.org/"
  url "https://github.com/phoboslab/qoi/archive/6fff9b70dd79b12f808b0acc5cb44fde9998725e.tar.gz"
  version "20260214"
  sha256 "01e919d166bd8dc7cf62b5a4a6544d69ceb9f511790c9b7d3f268f0355330332"
  license "MIT"
  head "https://github.com/phoboslab/qoi.git", branch: "master"

  def install
    include.install "qoi.h"

    prefix.install "LICENSE"
  end

  test do
    (testpath/"test.c").write <<~C
      #define QOI_IMPLEMENTATION
      #include <qoi.h>
      #include <stdio.h>

      int main() {
          // 1x1 pixel, 3 channels (RGB)
          unsigned char pixels[] = {255, 0, 0};
          qoi_desc desc = {
              .width = 1,
              .height = 1,
              .channels = 3,
              .colorspace = QOI_SRGB
          };
          int size;
          void *encoded = qoi_encode(pixels, &desc, &size);
          if (encoded != NULL && size > 0) {
              free(encoded);
              return 0;
          }
          return 1;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-o", "test"
    system "./test"
  end
end

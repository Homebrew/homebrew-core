class Plutosvg < Formula
  desc "Tiny SVG rendering library in C"
  homepage "https://github.com/sammycage/plutosvg"
  url "https://github.com/sammycage/plutosvg/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "49d5cfe772d3aa10cd4879f2f6e189f5083c08e4c8ea01bf3d5b87c97dfca7d2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "216817912278a835f499cc0406e8713426cf48ab2eb616368cab461b14d88380"
    sha256 cellar: :any,                 arm64_sequoia: "90bb8231955799e976b11762b91b01f4290f2337c2dabd4f5df5b20ded635c97"
    sha256 cellar: :any,                 arm64_sonoma:  "7a22b93a0c4b858440e7c6513755831063077f31c7feb78cfea98d992aa288c8"
    sha256 cellar: :any,                 sonoma:        "14a93d50e9f899a477633c4d6ffb60180904d70f7603163d670f2e20e75dac28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e1e7e72efd09a156c175a6266f61a483181dd8fe26657cd9288fe62dc5c7874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8d6ce5db89dd3eb9232f5fc103df9fbaa1dfc797e3cb536afe961d2f1cbc0ae"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "freetype"
  depends_on "plutovg"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DPLUTOSVG_BUILD_EXAMPLES=OFF
      -DPLUTOSVG_ENABLE_FREETYPE=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <plutosvg.h>
      #include <stdio.h>

      int main(void) {
        plutosvg_document_t* document = plutosvg_document_load_from_file("test.svg", -1, -1);
        if(document == NULL) {
          printf("Unable to load: test.svg");
          return -1;
        }

        plutovg_surface_t* surface = plutosvg_document_render_to_surface(document, NULL, -1, -1, NULL, NULL, NULL);
        plutovg_surface_write_to_png(surface, "test.png");
        plutosvg_document_destroy(document);
        plutovg_surface_destroy(surface);
        return 0;
      }
    C

    cp test_fixtures("test.svg"), testpath
    system ENV.cc, "test.c", "-o", "test", *shell_output("pkgconf --cflags --libs plutosvg").chomp.split
    system "./test"
    assert_path_exists "test.png"
  end
end

class Plutosvg < Formula
  desc "Tiny SVG rendering library in C"
  homepage "https://github.com/sammycage/plutosvg"
  url "https://github.com/sammycage/plutosvg/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "78561b571ac224030cdc450ca2986b4de915c2ba7616004a6d71a379bffd15f3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8bb298a75af6f0be2a1da9823aaa922e3f5bbe343b0add1816074d6a98140826"
    sha256 cellar: :any,                 arm64_sequoia: "b176ded158160d08ccd061219db379d7c1d9a741d6d7fa16486b51ce6694cc22"
    sha256 cellar: :any,                 arm64_sonoma:  "d8c82d8e2c4326ebfd1d2f64a80d2b88b121c6bfc74f7d39d6bb50bab2f8f5c5"
    sha256 cellar: :any,                 sonoma:        "cbe8b14915e492dd15013f93714abd6089ff412a5d7510a9ec4705826fd4a1b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09a1c1195783f379b4b7e43621a9b3a72cf3f443e603ae538d4eb7a023c1ab62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4764dfeaf0969f65d9d3f229a6a8a409c7aa385b8a204bf09c85d16ea8f80218"
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

class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "987374e3779f147ef5108780e90960e1d2d1aae8c9361ba1d418c8649a3ac947"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d13a93753b5a5b01e5b0aaf39afd98bd76a129d3b54ae788f667eca38feeee63"
    sha256 cellar: :any, arm64_sequoia: "9359a64289134011fea0ced0ec0c34dfa257518a43d0278dd494207457f98c67"
    sha256 cellar: :any, arm64_sonoma:  "84fa29f6c128199a60db1d68be5073d1ae6f1d4ba845a5e10edd7bc136f8e773"
    sha256 cellar: :any, sonoma:        "1f1113cfec65c9d482adca3491f748bcdf6e5718a88ea072d54efa1955c530ce"
    sha256               arm64_linux:   "fda98812409715e73a7a64020b1e30c261e41ab1cfee844cda019fd6faf26c68"
    sha256               x86_64_linux:  "80771a179a62ef4a5884addf353a1979102613e9cc1e727cd2c0e9403e3bbcf0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "jpeg-turbo"
  depends_on "libidn2"
  depends_on "webp"
  uses_from_macos "expat"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    depends_on "llvm" => :build
  end

  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <plutobook/plutobook.hpp>

      static const char kHTMLContent[] = R"HTML(
      <!DOCTYPE html>
      <html>
      <body>Hello!</body>
      </html>
      )HTML";

      int main() {
        plutobook::Book book(plutobook::PageSize::A4, plutobook::PageMargins::Narrow);
        book.loadHtml(kHTMLContent);
        book.writeToPdf("test.pdf");
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lplutobook", "-o", "test"
    system "./test"
    assert_path_exists testpath/"test.pdf"
  end
end

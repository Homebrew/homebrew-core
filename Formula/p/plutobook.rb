class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "23b2e8f54f28cc17fc70c09f241a34d0f3a593bfa5ec6fe70ea2a07a15f9bd70"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b25fb1303f27c8556f688f088b8f47bcde14283ca343217aa2f27cf44dc55d33"
    sha256 cellar: :any, arm64_sequoia: "0c808c3d39393a785624f169ffb0e8c045d575336ffa46995a00b06ea21de950"
    sha256 cellar: :any, arm64_sonoma:  "471c70a3ee9f84a2e862e57ff68c67f81617e7bedc1ebbe4e4a124e2e48ae8f8"
    sha256 cellar: :any, sonoma:        "02dbe5a79eb54e7895695cde0a2d55af881e03149bcedc374b7acd67e0d68246"
    sha256               arm64_linux:   "4c4a01a0ca1999f3aa9004e087c63f8df2f5707a25762e7fbf1f264097c45142"
    sha256               x86_64_linux:  "b1f71d02bfe21e8f0a2a8ba7cd13c9842ed6a7b523533b6a04e83442f35f91d8"
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

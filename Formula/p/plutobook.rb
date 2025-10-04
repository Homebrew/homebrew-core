class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "466f45581e9e274beede8a78f64ace3b3ad94d813d6c7b1a05594ab7e7f7fa84"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "baf08dda2b00b8182d5b44b174f7a2c347e9499208097b864458fcd6608182c5"
    sha256 cellar: :any, arm64_sequoia: "f0a1e4f60e2a9d82d7e484e3fd58bdbd445b334457416fb9a1b6a041995635a1"
    sha256 cellar: :any, arm64_sonoma:  "65cb56b31039b1f8bbd1fdc884d60c2c03a5b93297dcf214544716114afe3c48"
    sha256 cellar: :any, sonoma:        "945cdea6346df29eb75eac1e1860502b43ccc3456112449f08d27316d324c0b1"
    sha256               arm64_linux:   "52b691c9ae517ffc39e70875d29b13fec6cda6a035adf2c383f3865d871debad"
    sha256               x86_64_linux:  "adc4527c479627b49a983c3fd2e7b952256dac2d01b62f3e90c222adca8f9e00"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
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

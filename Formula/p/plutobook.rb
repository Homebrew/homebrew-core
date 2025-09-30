class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "877435ab906e7bbf105fc468929d810530de5670cd7ac9835813dacc8186b1cf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a4482691e3f6b59fcf4e9d5507c8c6d177acf9eecb95c45a0c079732acaed3bb"
    sha256 cellar: :any, arm64_sequoia: "d4e65432d81493336bda07e46da99a79e8ecbc7bdff9350a38d573c573f0baab"
    sha256 cellar: :any, arm64_sonoma:  "c1425a05752d86510956477b44be9dc27c2fec08df43b816a6018e631f8b7f6e"
    sha256 cellar: :any, sonoma:        "b4be3b1010ed84a21db5cf097d4cfc36ce0f53f5f36f0e766f4893cb09ddd195"
    sha256               arm64_linux:   "ab5733918ace4a581834bbfbd9ecbd19483d7fd8226defff0bec566a2c67994e"
    sha256               x86_64_linux:  "a543c1385fd882727580c45d23e1e70c566a3a13eab9483d8aa30a402fdebd66"
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

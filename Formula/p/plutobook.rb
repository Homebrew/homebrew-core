class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "fbcfe8c361df773f7f486d19c5e1f72a155bf641f50a926ebbcea8f9b2f39460"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "05d3de9d72829db418844c37280aa9baf49e440c96d71b2bea3af924f7f319ac"
    sha256 cellar: :any, arm64_sequoia: "388ccc0b18ca19e72753ba8c30ac30519c85e87765b8b9f98bb6f6febd857b81"
    sha256 cellar: :any, arm64_sonoma:  "4f795a8ae4b56190d9f909d3038cf7d69079d3742ea0dc3b17ea1a717a4f1905"
    sha256 cellar: :any, sonoma:        "70af1c555f2d27147bb617628320a6cc3196e73100c445a0aa4a1c68b5daa0d6"
    sha256               arm64_linux:   "24d5ad6babd437024ebe972ddf07bd57268eb0f4b306e46be74a75afbd8c956e"
    sha256               x86_64_linux:  "9f445a91ba8c9e2cffa07573b3095f1808599998b2c62886168584eaeeceb8d5"
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

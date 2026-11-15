class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "439758ab506d4578518bc1427c4ea4eed8e654d9e01cea327267156a83428310"
  license "MPL-2.0"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4fd715d512a456b6c7be15c149bc4a55eaaeea7c7e1afd609593d64e7d1bdda5"
    sha256 cellar: :any, arm64_tahoe:       "acd15ee010203e39db43c6d492e6734af921d3e95176f3cb8c5e9e60e77c8515"
    sha256 cellar: :any, arm64_sequoia:     "b6432537261d55e71f12f375787411c3ce2f5d37ceeba967f0b1d0c46ce6bbdf"
    sha256 cellar: :any, arm64_linux:       "4865af9d65751df506a3803e3e7df683a13ac3e92f67425460f84f795dcab14c"
    sha256 cellar: :any, x86_64_linux:      "381ad95d9310c2abf70f9e74717f6db7c4f81d06060cd6aa8d4d339cb9baaf4c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c@79"
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

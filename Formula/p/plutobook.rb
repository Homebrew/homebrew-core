class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "3d6106ff2890fc605881a4034c87da2ae8f79108b67228ab5c3fe9c7d96d78a2"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "53e1c4729c4b93c675f586468d93844b901d71ffae88ed83124adb2488677e39"
    sha256 cellar: :any, arm64_sequoia: "59b3e927df1b5a6064e3fc5d6048e33537b99aad4bf29fade226508105d2e326"
    sha256 cellar: :any, arm64_sonoma:  "1e51ec5a07940c621f1144959f6e5e9a59f42aac8d289194e8a61a4ec7a25de4"
    sha256 cellar: :any, sonoma:        "f387d4e9dcba508aab386705dc9baab6d1e02e8cb10e6fd4bf5ea276b21220d1"
    sha256               arm64_linux:   "bba0777404de4f17580d134f5a4e74099869a4b3925d4601c68cb9b1db9b3208"
    sha256               x86_64_linux:  "49fc22f05e616cb4061203e2dbcac6c8042615167cb0ec0d76fd7c8df20dd72c"
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

class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "439758ab506d4578518bc1427c4ea4eed8e654d9e01cea327267156a83428310"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b75effcb0b7ac4af2c64f46830cbc58e2b2508d06b7b3db32b01efe84c4efd46"
    sha256 cellar: :any, arm64_tahoe:       "cf24df0bcc1e2c1b397bab183fad79bf6559b925f803aed09b1b81ee76fe1ff0"
    sha256 cellar: :any, arm64_sequoia:     "ef51c93663e0b3d9153381685edf68a421a568b7e8760daaa82a0c7ede0b843d"
    sha256 cellar: :any, arm64_linux:       "490c1b740d155c1108d39d94e038d58b4e1a6709c09fa69af66b7f6371434fbb"
    sha256 cellar: :any, x86_64_linux:      "bd8faf5bd4f858e4df17871cd6fa1ea2631cb246685043deb7125ac66c2c2139"
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

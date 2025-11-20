class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "07d848da3f8390e475d456fece451a0eab93d841b73247faa4bb05a48267afc8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "04773213772ca2621f579c4193462dc13c6ad75cb55e0af2df7bd1e042bd4a41"
    sha256 cellar: :any, arm64_sequoia: "1e41e819f32e4de0cc028268d386ba1a172b726d851253416b310466d4c6f257"
    sha256 cellar: :any, arm64_sonoma:  "919768e38e1e3b8717f9f41c9494c980dbeaf83e90bbab4d95fc0e811d7b8d8c"
    sha256 cellar: :any, sonoma:        "b8c75873a5fe4cbf907cb6b9db0e2adb01ca654e2aa4e5706a869c09c01da019"
    sha256               arm64_linux:   "f0cf3f91eaea9899d5f2c642be9e9c0e4104bdb473d2aa850695db7502388599"
    sha256               x86_64_linux:  "bc596e5953300f2ce91d4c9a946877700ba83930d970cec936381279dcccec4a"
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

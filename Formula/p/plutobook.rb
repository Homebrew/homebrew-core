class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "832376e16c9604d8dce68425eacf06b6e475bc6eab75251464e26ac674807e2f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b7b31876138b4c305719a9516ea3931ab6d1c97f7a6b85c9d31616abae55c435"
    sha256 cellar: :any, arm64_sequoia: "97bec7b8391ef9df32f955c2360c932fb602842086c23c2a985dd8cb48ea021c"
    sha256 cellar: :any, arm64_sonoma:  "c9857958665f5c1e39f6c2a3bfa24c0e3f1836fa42415dd78a490d8fd58bbd67"
    sha256 cellar: :any, arm64_ventura: "00a280132ef37a3393bcd50b8406329bba28862cb400d6e0a48c3709d1d1deac"
    sha256 cellar: :any, sonoma:        "1e6fa58302781f99633a65e3f2ffd8aef519be3c894be1cae27228fbf30ac915"
    sha256 cellar: :any, ventura:       "1478dfe0f53f682ccdcada3be0f62e35c84afd48317639cb9fa359e2f910d545"
    sha256               arm64_linux:   "47ce45c4de5ff118a1c7c63bdc9adc7a3256d376cc6d2d4db2b67ebd464f1056"
    sha256               x86_64_linux:  "3b14e4ad09e9248353912705542ade446a9e3b0b9738d555c753798794959b79"
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
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    depends_on "llvm"
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
    if OS.mac? && (MacOS.version == :ventura || DevelopmentTools.clang_build_version <= 1499)
      ENV.llvm_clang
      llvm = Formula["llvm"]
      ENV.append "LDFLAGS", "-L#{llvm.opt_lib}/c++ -L#{llvm.opt_lib}/unwind -lunwind"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lplutobook", "-o", "test"
    system "./test"
    assert_path_exists testpath/"test.pdf"
  end
end

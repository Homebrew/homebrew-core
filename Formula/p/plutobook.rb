class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "8f344b446d62a1aa43855e0b0b142aaa192f85ed16b07f9791715da5e3343c3e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "68e18b53ec30bad2c021728e221bab88e647c6b7c92fb9fb764482499bad9817"
    sha256 cellar: :any, arm64_sequoia: "c2d75d81af62fa8bb5c26fa7007f81315a45319b5c6fbab63db5269225e1337a"
    sha256 cellar: :any, arm64_sonoma:  "2c9d4a32319a534d4257d9da82a00456300c2e90ea9319bbd94786d687e8bb19"
    sha256 cellar: :any, sonoma:        "124eda3c1f50005fe02dbe28c49b51dfdf1f14ecf4eec00f269a04dcbc047732"
    sha256               arm64_linux:   "a33b96066e2d14ed16ddf10d228f27891b193b2c1bd753109f2c1a357b3f8e6f"
    sha256               x86_64_linux:  "621757a68a187515024a26cd72d6d95e0c37c133d6dd2e1374b26d17e872a659"
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

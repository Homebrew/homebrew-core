class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "38e0af00d983d385a67cbabb26430c21f60c98d232d5846f2ba17f6990176ee0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e686a685a055a016688845d10343d742708e4527f3060dc891b0aa24ef439a5c"
    sha256 cellar: :any, arm64_sequoia: "5709a14e3aa3114a9cabc2ca13411efc39f555441eda4ab3651b86d4ebf682be"
    sha256 cellar: :any, arm64_sonoma:  "655c4904cc008096decadff24434ab8417974513a2fd62ec43db1639a12717ea"
    sha256 cellar: :any, sonoma:        "538785bd0c3964ebf4dea441ae093b9f472714fb8bb768b5ed0ff5ee213b5011"
    sha256               arm64_linux:   "f77ce6f16a3c48209ab19598d8a918800674d170271719cc20496ceae7e73eec"
    sha256               x86_64_linux:  "ab56e76ff401acb1d3e0bb10acad278d3caf6da5d03b3d0a980b88b4902e88b0"
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

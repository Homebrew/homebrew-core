class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "d676cd84fcb49df95955a0186469a7056abce963f5affb55b8479c3e44709f0b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "37f8b52a2197a33e9bf58893a1b8e5202eac820569a24838bc408931a9611c67"
    sha256 cellar: :any, arm64_sequoia: "6f13f03d7504e1bc079a8897756660c7e0c5d543b209ca45544d29c177890710"
    sha256 cellar: :any, arm64_sonoma:  "7973baed15269ddef173debaf0c3bd4dac21e020480fa6d5c78a079e5fdb51a4"
    sha256 cellar: :any, sonoma:        "7da1a5eb781c17d29a55bb28c1dccbc8717e5b06cbbe66cb76572c2bf7b9cef9"
    sha256               arm64_linux:   "c21378f017893d8e7c21dfed72fdb40387682ef6b5dc3b925830e0f8ade4183b"
    sha256               x86_64_linux:  "4e8826986513903ddf90c44c7a9ef6e26ddd2c76c4554bdab9c41a6c267f0233"
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

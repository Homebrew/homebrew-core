class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "050cf46a9b00c7ead5ee7510b26689cc760772f70523c8676b8c8870bc2d8f0a"
  license "MPL-2.0"
  compatibility_version 1

  bottle do
    manifest_sha256 "15727a6e73de70dcfae863646cb437b4fb4b715c9db4ee56cb0274f3bc42f884"
    sha256 cellar: :any, arm64_golden_gate: "10d29b7503f307bb031392978ac945e1c1bc15a419b3222d04c633bcacbf8bc9"
    sha256 cellar: :any, arm64_tahoe:       "e6e8e7bdbc8ce49c7addffc292d078a993f1a922d87fadb634f33a153c8e53a3"
    sha256 cellar: :any, arm64_sequoia:     "cae41530e60c1e5291c775b85c9f4c234221204e392bdde0eecf35e58cc21166"
    sha256 cellar: :any, arm64_linux:       "8661cc1ed177021348dd9158f964811aa5055c1495167f342d6286179f9c2587"
    sha256 cellar: :any, x86_64_linux:      "ad12fe9d77156178d1b77f8a1a7cf963dc17f05349ad77aa5abd08bc4b1bf0e5"
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

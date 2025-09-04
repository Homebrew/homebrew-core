class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://github.com/plutoprint/plutobook/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "51d984a6efd6137fc2fa3416f8fee5d0fb9c2e17c3a0614f349de3af9f7aa093"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "1ca3e3159e11d28e421bcc5203d3321a2e14b63b90b1cc8f1f1a8a4400ea44f8"
    sha256 cellar: :any, arm64_sonoma:  "9d7bec20c8fb07c813c38364dea512b36ef7a37939c203c931e385518f76d7e8"
    sha256 cellar: :any, arm64_ventura: "bb819b4c2de899d3e0ee1c600830de3151ea86284d13d754080ce5513856dc9e"
    sha256 cellar: :any, sonoma:        "5445fa9a5c5871165846b93db5a53ff5d3d55fe7aa9eadc9d41bd9228dbf1cad"
    sha256 cellar: :any, ventura:       "7f3d14be468c6d71a128b67f65914ec817c293a831b810195e7f9fdcb4f813b8"
    sha256               arm64_linux:   "e9a1e3b91decdbb1fca4f61a579b8f10d11395f246bc603ecf7cdf7e7b269e61"
    sha256               x86_64_linux:  "95f3995698d369a7f6ecc75820c9d919fadcc5311010d34de15f78fa584b5f76"
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

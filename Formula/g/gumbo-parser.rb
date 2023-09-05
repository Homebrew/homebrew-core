class GumboParser < Formula
  desc "C99 library for parsing HTML5"
  homepage "https://github.com/google/gumbo-parser"
  url "https://github.com/google/gumbo-parser/archive/v0.10.1.tar.gz"
  sha256 "28463053d44a5dfbc4b77bcf49c8cee119338ffa636cc17fc3378421d714efad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dcfdbc776b1c99ced008e359753b09a8b8074dd2cd9eabad4d8941cb3516d56b"
    sha256 cellar: :any,                 arm64_monterey: "4a6e3a1bf98e9e1cae366ca87ca1edd454565ae058d654bd15f2ca363f7a3fb4"
    sha256 cellar: :any,                 arm64_big_sur:  "9812d6af063b978c1314c5bc6f1eedcb34d9e395174ba9b68932feb69ed3f2e0"
    sha256 cellar: :any,                 ventura:        "a9042d2c69a6063a6b8f9c0f5ea0f5f77df66ef22fddeb0b1b04a163df1184fc"
    sha256 cellar: :any,                 monterey:       "15cc63bc7c0a91adbcbf51b50ec0be98a3a2d3ef2b495f4c6c3506ed4565ac9d"
    sha256 cellar: :any,                 big_sur:        "917387609673137f253bc7f1effcb26a710c8a315f4d194de0bed0c6e21fc3b2"
    sha256 cellar: :any,                 catalina:       "c922c8ec4425cef96e3283bace0ffda97cdd5f4946ca151da69045c6ce80ef06"
    sha256 cellar: :any,                 mojave:         "aa6ed085625f40a65ecead082bd711dcb16af9aed6f74372edb7dc19e44fba5c"
    sha256 cellar: :any,                 high_sierra:    "ed0957fe59981b55c1baf149022a5b0f3a163f1a6eb6e03e402da2f018406b9f"
    sha256 cellar: :any,                 sierra:         "7c911b3f74827405abdf92cb6f6265cf7185043af4101d851eb68c5e69ea71e6"
    sha256 cellar: :any,                 el_capitan:     "56f5446eb431b628655748659a8a7479466e00addf7d90070464364a3f3cafa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ae8a4b287fcbedb1cd48eeb3c26a257b2829401e23c0026dafb04461dcf07ae"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "gumbo.h"

      int main() {
        GumboOutput* output = gumbo_parse("<h1>Hello, World!</h1>");
        gumbo_destroy_output(&kGumboDefaultOptions, output);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgumbo", "-o", "test"
    system "./test"
  end
end

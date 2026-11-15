class GumboParser < Formula
  desc "C99 library for parsing HTML5"
  homepage "https://codeberg.org/gumbo-parser/gumbo-parser"
  url "https://codeberg.org/gumbo-parser/gumbo-parser/archive/0.14.1.tar.gz"
  sha256 "ba5d13b9b508ec693613b3b61518163aced38f8e885f7e28dc047348a4e61365"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4b8258521e8264f4c1ce161bf8010e8a3bea82a45cb5964979de8f59b5407aad"
    sha256 cellar: :any, arm64_tahoe:       "f249b09f0538e5150e94cf91bb606a1593c12ebf8939b9b49bd1d8716b342667"
    sha256 cellar: :any, arm64_sequoia:     "f25fd6ba73915738e518a72469eb9cc6b2a7ad96dea0c63e9e0fcf891ac6369c"
    sha256 cellar: :any, arm64_linux:       "b392c88b12b3a03ce0d3b526d801e63deb8c3ea3b5da0c557b3981c6f6536427"
    sha256 cellar: :any, x86_64_linux:      "27d8f965b1538d6427a962e1ebf8908bb263f3ac0aa634e33ccbac4bef51987b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  deny_network_access!

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "gumbo.h"

      int main() {
        GumboOutput* output = gumbo_parse("<h1>Hello, World!</h1>");
        gumbo_destroy_output(&kGumboDefaultOptions, output);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgumbo", "-o", "test"
    system "./test"
  end
end

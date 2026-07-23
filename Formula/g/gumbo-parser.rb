class GumboParser < Formula
  desc "C99 library for parsing HTML5"
  homepage "https://codeberg.org/gumbo-parser/gumbo-parser"
  url "https://codeberg.org/gumbo-parser/gumbo-parser/archive/0.13.2.tar.gz"
  sha256 "90bea83283760339da194fb90112a532854c13cd1eabdabc7ef7a4dede1dbc9d"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "5f81617fa746f60ded3bddbb1254836ede96ed65636f382122c72462a8cc11dd"
    sha256 cellar: :any, arm64_sequoia: "b3524456aa1c3de29e95b03a256327a2fb1558e542828abb55f34b875600ad5a"
    sha256 cellar: :any, arm64_sonoma:  "7305c72642f1d6d2f1ab3cfd105bcbca0d2dbce20b7bb85e597dcfe5f0505853"
    sha256 cellar: :any, sonoma:        "a0a1b68812151bf187dfb4076c8f9e629f7fb8152f7eef52d325210f2db01613"
    sha256 cellar: :any, arm64_linux:   "b3ceb5af160a71cf77155b4f407eef8a1145640f6a2a9887b8a70f87dc0fb9dc"
    sha256 cellar: :any, x86_64_linux:  "17adb02cec39144ccfe37434a890131dbca55e4452648740bff1e5350c41df04"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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

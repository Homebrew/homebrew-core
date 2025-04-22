class GumboParser < Formula
  desc "C99 library for parsing HTML5"
  homepage "https://codeberg.org/gumbo-parser/gumbo-parser"
  url "https://codeberg.org/gumbo-parser/gumbo-parser/archive/0.13.0.tar.gz"
  sha256 "7ad2ee259f35e8951233e4c9ad80968fb880f20d8202cb9c48f0b65f67d38e61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d8e1aab75de31c09b003bfabdf9e1dcd5f8416b58cecac9d7c1cd24cc8de9717"
    sha256 cellar: :any,                 arm64_sonoma:  "06d89a5fd5021a5217254a3be2b89ab7c67a01814043df4fe073578df0980bc3"
    sha256 cellar: :any,                 arm64_ventura: "eb6f09225d057ba68927c42c3c9e0f6f52de37a41f895fd22923fa024c74d526"
    sha256 cellar: :any,                 sonoma:        "145e843822f4a67cece0704eedd7f5e6c0f7baffa0b7a99d66e70a77eb1a3b7e"
    sha256 cellar: :any,                 ventura:       "69dcb8188354001bfa3303a16e450304082900376acef548f3c1aaa647e9df29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc715b25ea4c526a5469bbb70e2125e10b1405dd8da01d58cefd94636f510eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "027fd9b2bf818a7966cb874991ba3ef8279e63e7f45a3ddfe04a5898848c09ca"
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

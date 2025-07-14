class GumboParser < Formula
  desc "C99 library for parsing HTML5"
  homepage "https://codeberg.org/gumbo-parser/gumbo-parser"
  url "https://codeberg.org/gumbo-parser/gumbo-parser/archive/0.13.1.tar.gz"
  sha256 "1a054d1e53d556641a6666537247411a77b0c18ef6ad5df23e30d2131676ef81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4fc6871a20b27a9e5462740793f01648b5a06d97f53e1c2e3a1be9b0b39eb700"
    sha256 cellar: :any,                 arm64_sonoma:  "1e1b191a7db8660d1625533cdd4f56f1627505c8e41d6d40eee4ad62d82d62ce"
    sha256 cellar: :any,                 arm64_ventura: "ad2bba838cfdc4dabbdcb27921cacade5606f6154d0f4dfc3afbc6e50c1d8e37"
    sha256 cellar: :any,                 sonoma:        "fe7318f9114cdd67e66d6df0fdcd5ffd3d064bfff7d1adc87c0b2cf09c28fbd5"
    sha256 cellar: :any,                 ventura:       "e2cf0436b1de9343e4cf39d4f6c10bbbbef875a7ab45e5c6eee482f5d94a7fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fa8e5deaf3b5d23b3cd03388c53cab34b0a3056936bc3faee12a59c65fcc8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6bd03113d6c4cfb31850dd01825240596918b7463f93e000f606a1f6a65202c"
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

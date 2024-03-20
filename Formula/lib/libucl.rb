class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/refs/tags/0.9.1.tar.gz"
  sha256 "e3efc73db5dfbfd4866bbff46f73efbecdb6b8f851e604d3a22ea65d5ede7b98"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9939f684c190af0b9c4b35ca741570a01cd95d02165bc74a09e3e4d41db6ccfc"
    sha256 cellar: :any,                 arm64_ventura:  "e98cc86fda69c097ea47a05f6dfaab052860bc5d53e41bea51ec125208c20475"
    sha256 cellar: :any,                 arm64_monterey: "95e6c12559afd25611c8adfae612753b464ff8c2be205ba954f8c463e8e3213a"
    sha256 cellar: :any,                 sonoma:         "38b8fcaf828f33014fea25fdf1e8e38cc9f1bcb6cb8068cfcf2f457aa0551fbd"
    sha256 cellar: :any,                 ventura:        "983880e9b298a75a20bb0d05dbc5574cf36313f99f383974debf189faee58664"
    sha256 cellar: :any,                 monterey:       "39722b87bbedc6d98d4efdc0e0714da0b5aa3c43a10dec12b51f98a79c09441e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94f634b3a3a932fa2a74c11b3e79c07ce7f4bc97a74c3b6c8682eedfa6ab0700"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-utils
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ucl++.h>
      #include <string>
      #include <cassert>

      int main(int argc, char **argv) {
        const std::string cfg = "foo = bar; section { flag = true; }";
        std::string err;
        auto obj = ucl::Ucl::parse(cfg, err);
        assert(obj);
        assert(obj[std::string("foo")].string_value() == "bar");
        assert(obj[std::string("section")][std::string("flag")].bool_value());
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lucl", "-o", "test"
    system "./test"
  end
end

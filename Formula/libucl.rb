class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/0.8.0.tar.gz"
  sha256 "af361cd1f0b7b66c228a1c04a662ccaa9ee8af79842046c04446d915db349ee1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bb8581d850dcdbbca18612371aaef23cd4e9d0948ae22a3ad35dda94f69b5874" => :sierra
    sha256 "f505e0d68fbcb0cd33ffbd71ea2e14aea67742c44cd665810cf11447723d91d7" => :el_capitan
    sha256 "d2132009336951013a66d39bf84f49e1b6a167705bfa6006fbdadd223a5ddcb5" => :yosemite
    sha256 "5f5396fc96e31d5114f8b8f708805a13c9781b96ca530445f0e7e80f3623e6b6" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "lua" => :optional

  def install
    system "./autogen.sh"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << "--enable-lua" if build.with? "lua"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <fstream>
      #include <iostream>
      #include <string>
      #include <ucl++.h>
      #include <cassert>

      int main(int argc, char **argv) {
        assert(argc == 2);
        std::ifstream file(argv[1]);
        std::string err;
        auto obj = ucl::Ucl::parse(file, err);
        if (!obj) {
          return 1;
        }
        assert(obj[std::string("foo")].string_value() == "bar");
        assert(obj[std::string("section")][std::string("flag")].bool_value());
      }
    EOS
    (testpath/"test.cfg").write <<-EOS.undent
      foo = bar;
      section {
        flag = true;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-lucl", "-o", "test"
    system "./test", testpath/"test.cfg"
  end
end

class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/0.8.1.tar.gz"
  sha256 "a6397e179672f0e8171a0f9a2cfc37e01432b357fd748b13f4394436689d24ef"

  bottle do
    cellar :any
    sha256 "270f1f5a88f1a9116398d45fbe041d92d1f244ae247a1dfc1dd93891503f8b41" => :mojave
    sha256 "e30a7ebee16c366f71c7fb29b38a41b1c9e95cfc1f373f9d7ea7e1bbc47b8617" => :high_sierra
    sha256 "9a39086f31e5dbbafb5524f0d5a2609bdfc2155b436b6c3db99f3689bc507be1" => :sierra
    sha256 "ba333fada04cdb99bfbfeefdbe21d2261baa76a5f814278c08a57b7821d27ace" => :el_capitan
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

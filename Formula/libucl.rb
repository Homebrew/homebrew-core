class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/0.8.1.tar.gz"
  sha256 "a6397e179672f0e8171a0f9a2cfc37e01432b357fd748b13f4394436689d24ef"

  bottle do
    cellar :any
    rebuild 2
    sha256 "5f845b8255109ef447e502ae4e409272c0a20c77b46f53ef717db33c9fb02a8d" => :mojave
    sha256 "77547a51a2e038ab2f26123fb39ecd12e1ba248aa857dc01c75892554c404330" => :high_sierra
    sha256 "20f8f84cdefc801f89531a97ef9d6964f84199040e9c7affda48848171c6f096" => :sierra
    sha256 "ca86c64fe729bae95050208ef904752473da24592e9221c774e65206df3d8567" => :el_capitan
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
      --enable-utils
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

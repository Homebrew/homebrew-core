class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/refs/tags/0.9.4.tar.gz"
  sha256 "319d8ff13441f55d91cd7f3708a54bd03779733e26958c2346c5109014520aaf"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d558ba4973cfffdba49a2728ca9945ae938c9f8b18cb1170919e51fad82338d6"
    sha256 cellar: :any,                 arm64_sequoia: "91ed40ce3f7472550719d08c48b0cc9d54a34f971ce628b79ae73f2e23f766e8"
    sha256 cellar: :any,                 arm64_sonoma:  "8764b8b400a7110ad55bac3f8e27ad987d1f2f64fd0de17e511200b1d77e94ff"
    sha256 cellar: :any,                 sonoma:        "e5c65c529626b4433ad606574b842312534f05e049df186251955e55c66af882"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00fd13ad0b9d87427f303f93466f006e14e9f5d2bc14b64aa87487c9d3f0320d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba43e46b697f805c3908c81591fd5163703a51e8deebcf372fd01510041a02a8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  def install
    system "./autogen.sh"

    args = %w[
      --disable-silent-rules
      --enable-utils
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lucl", "-o", "test"
    system "./test"
  end
end

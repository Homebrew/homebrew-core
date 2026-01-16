class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/refs/tags/0.9.3.tar.gz"
  sha256 "40d5a130132e896f63260daf57deca0eab582deb660d4bdbf60608bace2d6d92"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44f9e4cdc412ba7dde7da0928db9b6e1e52321cfa11085b4ebd2fe45a42712de"
    sha256 cellar: :any,                 arm64_sequoia: "e8b31a23679f906e813aa6376916a40c5f9c4f6385b552286a2fb21ffeb2b6f9"
    sha256 cellar: :any,                 arm64_sonoma:  "a0691fa0b45ce61ba8cb8c46c656067a5741445d2d1e71266c2f739c70b52464"
    sha256 cellar: :any,                 sonoma:        "de35ee77015bbcbca540b2e83ca8d5075b8279b70ef15a2245a8ba7f7efe0b36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6a04ed5b032e880db362d0ccd2021fbcc232a9a5267a706b13b4be5b39c94c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "273cb2b4eec8ab690b750d3e2741c71a54dba310201e91b632577637043bb615"
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

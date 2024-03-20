class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/refs/tags/0.9.1.tar.gz"
  sha256 "e3efc73db5dfbfd4866bbff46f73efbecdb6b8f851e604d3a22ea65d5ede7b98"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d10edbf3de74217cc43b407dee41a3e86b97b0471fafc865718d457a6639c656"
    sha256 cellar: :any,                 arm64_ventura:  "e26c5ce20cf0303dff5d20603695218f31db041ddeaba1d04426540d7ee6a800"
    sha256 cellar: :any,                 arm64_monterey: "5f8ce4e046c5d829a782064241c2755935094c838efc806512a693ee03dab0f5"
    sha256 cellar: :any,                 sonoma:         "40b5d7c8b3835c2a79f157b900cefcb414e39036d4f40fb4fde686fd6eb3c8c6"
    sha256 cellar: :any,                 ventura:        "0a5303428c25c621aeaca336db4657af4dbe1d550451e7c6d5d6ccff8edcccce"
    sha256 cellar: :any,                 monterey:       "7af8bebd350d6e89072ea95a6d99d12ea08df619367d05fc7264150dd4c6f040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "975f5d76cbdf5078b43be098cd5f806b3cc91851f27eb78d23fd6ed9ab1a6c2a"
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

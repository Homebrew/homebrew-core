class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/0.8.1.tar.gz"
  sha256 "a6397e179672f0e8171a0f9a2cfc37e01432b357fd748b13f4394436689d24ef"
  license "BSD-2-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_monterey: "b034e87eacaa35c1394579d465a2c8bdbfc1e0ea9569b039c0bc1a4eb3264368"
    sha256 cellar: :any,                 arm64_big_sur:  "55fcc8229b3dece974f8dad4e4c27ff4777817d0a19fa8399c822b4c869d05c2"
    sha256 cellar: :any,                 monterey:       "1d8b096d33f1d0ca2080dbd3c63fab294fa801ae34ec078aba66c918da03bec4"
    sha256 cellar: :any,                 big_sur:        "bc12495d53c1480a146b64d6f4312fdbfe10b5e7c7dc5d465255aab13b0b510e"
    sha256 cellar: :any,                 catalina:       "8ff53b6da5423f7b6e11b6173b4b720d3563b1a24243ea4f977cf269d67aeb4c"
    sha256 cellar: :any,                 mojave:         "1ffddb657d95f504ba3b7331f5dbbd995c5d237cda3f736e99182a16a8e8181d"
    sha256 cellar: :any,                 high_sierra:    "dd5dbb4eb7e3d37816acc4f3bc2842c8e91caeb4a6f058eed75cab9d72192315"
    sha256 cellar: :any,                 sierra:         "5c477e0feb163dc955e89eabf97cae445fefc9c920fe46073c85af348535d7cd"
    sha256 cellar: :any,                 el_capitan:     "93e7d66507c386c9fe720b5f4c77d3b719574b7c311319cddc09bcbda659bce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6e2d1c37ece770a3fc50ee265d293175c5cc16370187a9356fa3dc92246b01"
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

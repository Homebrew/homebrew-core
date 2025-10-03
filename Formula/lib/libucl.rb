class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/refs/tags/0.9.2.tar.gz"
  sha256 "f63ddee1d7f5217cac4f9cdf72b9c5e8fe43cfe5725db13f1414b0d8a369bbe0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e42ac56fff1cba6f85e3d6d07d831424149d972f244f5c108b10ac0d9257fe00"
    sha256 cellar: :any,                 arm64_sequoia:  "7fb7a6da5d226f44461cc63016b2b0254ec73ee5506772c98d2c9c12eb5be185"
    sha256 cellar: :any,                 arm64_sonoma:   "00ca25427fee2390ea39e75173ae8c844b816a21bad5b205d76d7961dc81614e"
    sha256 cellar: :any,                 arm64_ventura:  "04ee73714b6d52de15235224a1a4fd72ca07d7e39fc5324e6fcc630a27ecc84f"
    sha256 cellar: :any,                 arm64_monterey: "64174ea202ba8d56e10a61a2835800ad180ae649613184b7e55b801b0a3f260d"
    sha256 cellar: :any,                 sonoma:         "404849ecb35a31bc40df771fca0bfe75da4d1b552e1073526d645ad25094f8b6"
    sha256 cellar: :any,                 ventura:        "28caf0f7502a50965881748e9d6f66fa0481be2ca8d3bcf75a296621aebfe805"
    sha256 cellar: :any,                 monterey:       "b349883d0fdfccac70c706f8a9cf439bb528f59c9f2dbc89a2d3c80d2dfcdcaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f85409dcfcae075574b158cfc45a43893b3b351885c8d2f1cdb2c5b1a3c79f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c28950d57c3275bddb3df7ee14c7ca99f94e49e0baa58be832a17b9928d0ed0d"
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

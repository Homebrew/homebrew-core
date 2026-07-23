class Litehtml < Formula
  desc "Fast and lightweight HTML/CSS rendering engine"
  homepage "http://www.litehtml.com/"
  url "https://github.com/litehtml/litehtml/archive/refs/tags/v0.10.tar.gz"
  sha256 "7700eced92847d34ad9846b138cf195a9c974b519be70de58797880ae9da649e"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0c80f1c5ae85acca5068625a06a74fd02185a7901ecd1312b47556b91629152e"
    sha256 cellar: :any, arm64_sequoia: "772d7fb4f152da4df2c9f5ac0bf209811a5692e0a646642e442eaa8399a8984d"
    sha256 cellar: :any, arm64_sonoma:  "80e01825325c8244ce63c6b0680bc64c2b1b5e6e52d72e700f3906648979080b"
    sha256 cellar: :any, sonoma:        "5e2d7ac2a3ff0403c43a4b4a9b75b79422c923416793085b011652724063cdb0"
    sha256 cellar: :any, arm64_linux:   "a272ca38840e02bd0faccb8a6bd0c5d757782adf3d5c3faa9ce84eedeb850877"
    sha256 cellar: :any, x86_64_linux:  "727fa7f9bec1cdec5baad6e8771e3e6106db31bf2c4cbadbd0779e915387a285"
  end

  depends_on "cmake" => :build
  depends_on "gumbo-parser"

  def install
    rm_r("src/gumbo")
    # FIXME: gumbo-parser doesn't have a CMake configuration file or module
    inreplace "cmake/litehtmlConfig.cmake", /^find_dependency\(gumbo\)$/, ""

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DEXTERNAL_GUMBO=ON",
                    "-DLITEHTML_BUILD_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <litehtml.h>

      int main(void) {
        litehtml::css_selector selector;
        assert(selector.parse("[attribute=value]", litehtml::no_quirks_mode));
        const litehtml::css_element_selector &el = selector.m_right;
        assert(el.m_tag == litehtml::star_id);
        assert(el.m_attrs.size() == 1);
        assert(el.m_attrs[0].type == litehtml::select_attr);
        assert(el.m_attrs[0].matcher == litehtml::attribute_equals);
        assert(el.m_attrs[0].name == litehtml::_id("attribute"));
        assert(el.m_attrs[0].value == "value");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}/litehtml", "-L#{lib}", "-llitehtml"
    system "./test"
  end
end

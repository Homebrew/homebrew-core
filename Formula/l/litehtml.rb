class Litehtml < Formula
  desc "Fast and lightweight HTML/CSS rendering engine"
  homepage "http://www.litehtml.com/"
  url "https://github.com/litehtml/litehtml/archive/refs/tags/v0.10.tar.gz"
  sha256 "7700eced92847d34ad9846b138cf195a9c974b519be70de58797880ae9da649e"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3144634607fd48ab5a17952215ea0ad7116629c649b6c3070d72c354090fc9d2"
    sha256 cellar: :any, arm64_tahoe:       "c04934f95374b07ad5d68df56857dd65da292f20a0a3ebb421eee96d0b2dfd8d"
    sha256 cellar: :any, arm64_sequoia:     "e378dc8a204fb6b918786c6317f83630948af24976d148ad664531e9d6a37fe8"
    sha256 cellar: :any, arm64_sonoma:      "36cb6a5b5d456b522e3fc3d188de7bde37c9556a107372c07ca51a12d9e085d4"
    sha256 cellar: :any, arm64_linux:       "c5e60542eb5d95723dcf2bd656c7d5f1bb0efe79547b0a9ffea069741b2da976"
    sha256 cellar: :any, x86_64_linux:      "79e90c3d8b668391e80b25e41c4320af3355cc9ede8f7152f805ee80bb5f663b"
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

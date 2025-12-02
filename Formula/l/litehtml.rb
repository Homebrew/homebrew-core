class Litehtml < Formula
  desc "Fast and lightweight HTML/CSS rendering engine"
  homepage "http://www.litehtml.com/"
  url "https://github.com/litehtml/litehtml/archive/refs/tags/v0.9.tar.gz"
  sha256 "ef957307da15b1258a70961942840bcf54225a8d75315dcbc156186eba35b1a7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d07e7a815a2fd6e9a44e8f52233ea5a979d41b9dbb24828b0a53508df0ef6e39"
    sha256 cellar: :any,                 arm64_sequoia: "8e83b6bb6e9576cfc87e68c3e2af8395ade9410909e69fe6b0e7dd0fa84628e6"
    sha256 cellar: :any,                 arm64_sonoma:  "f523092d1e8b207643978a8fb84d9c3734c5ff123eaf3c8ef3a5ee5dd040b9ef"
    sha256 cellar: :any,                 sonoma:        "bd159f548833cb3e58a2ccd7637661121d68b20ac24e2023f15d0361d2876b0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e533110ac64cb56657b385b8b9dca426ef402625b286de737caabf30a3b6bf24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b010dde65bdf09f5d5f5bc991512f64d21ed598532966b212123e643e4e1dcd"
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
        litehtml::css_element_selector selector;
        selector.parse("[attribute=value]");
        assert(selector.m_tag == litehtml::star_id);
        assert(selector.m_attrs.size() == 1);
        assert(selector.m_attrs[0].type == litehtml::select_equal);
        assert(selector.m_attrs[0].name == litehtml::_id("attribute"));
        assert(selector.m_attrs[0].val == "value");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}/litehtml", "-L#{lib}", "-llitehtml"
    system "./test"
  end
end

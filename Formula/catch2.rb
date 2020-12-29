class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.13.4.tar.gz"
  sha256 "e7eb70b3d0ac2ed7dcf14563ad808740c29e628edde99e973adad373a2b5e4df"
  license "BSL-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "10297553fd45e5400ccdea141a4dcd446e7fc0d435ff6fc6642bd085442c4e86" => :big_sur
    sha256 "3684992b111b6dece59df812ba09181fb62a22d2b518c5e7dbc07acd76d2481a" => :arm64_big_sur
    sha256 "958032c9813ff1bed035894299c9acc08c87503a14c1a32f0ad60cc9cc6c32ba" => :catalina
    sha256 "09118ef07a7fa43e6327e5034b2f2aa3ba02aae42c86f6aab1d1ee7d914f0dd4" => :mojave
    sha256 "71e22734d3fe0c6c9396679432fa8c5100f176055cfd865e2eb195a7b3634fe1" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define CATCH_CONFIG_MAIN
      #include <catch2/catch.hpp>
      TEST_CASE("Basic", "[catch2]") {
        int x = 1;
        SECTION("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SECTION("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end

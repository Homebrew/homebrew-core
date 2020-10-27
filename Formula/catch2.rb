class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.13.2.tar.gz"
  sha256 "5e39d9199f4f174dc3c8896fb4cf0a2ce9b9c358ae759b87fade6d615ca2d27e"
  license "BSL-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "11de128f69768338a297dacc7a9b0e28fa7d43425d073c98e72af59aa4baad42" => :catalina
    sha256 "3f3361a3e0b107e3a92373802228af7cc4eaafc6891295480d675d8e15388128" => :mojave
    sha256 "416383794859afa0cb66cae949875931f95dc50877ae0d1d3dd092a8d82443a1" => :high_sierra
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

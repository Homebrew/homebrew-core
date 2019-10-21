class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.10.1.tar.gz"
  sha256 "dcbbe0a5f4d2a4330bdf5bcb9ef6a02303d679d46596e4ed06ca462f2372d4de"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f20327dae1a368d146c016d3e21d40cd4d04c86e940ea12cc906c5c5ac48cfb" => :catalina
    sha256 "9f20327dae1a368d146c016d3e21d40cd4d04c86e940ea12cc906c5c5ac48cfb" => :mojave
    sha256 "9f20327dae1a368d146c016d3e21d40cd4d04c86e940ea12cc906c5c5ac48cfb" => :high_sierra
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

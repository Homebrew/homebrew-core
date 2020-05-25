class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.12.2.tar.gz"
  sha256 "4075d12aa4dc9a5bab00e82e0140b2969b88b8524b224e06ee129fabb9e2944b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5e3629556bfd21e1376c3d05ee459bd29d0065480e1c76c1fcf93d9656542ea" => :catalina
    sha256 "a5e3629556bfd21e1376c3d05ee459bd29d0065480e1c76c1fcf93d9656542ea" => :mojave
    sha256 "a5e3629556bfd21e1376c3d05ee459bd29d0065480e1c76c1fcf93d9656542ea" => :high_sierra
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

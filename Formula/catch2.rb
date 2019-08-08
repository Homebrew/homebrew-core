class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.9.2.tar.gz"
  sha256 "54bea6d80a388a80f895cd0e2343fca72b0d9093a776af40904aefce49c13bda"

  bottle do
    cellar :any_skip_relocation
    sha256 "3955ab8de6b6a282ab9c1ba76f28c6d3899bda3c8d00d16a966cdfebebde7eb3" => :mojave
    sha256 "3955ab8de6b6a282ab9c1ba76f28c6d3899bda3c8d00d16a966cdfebebde7eb3" => :high_sierra
    sha256 "a2662b0e5a0a1f30193314f94f4bbe9b42dec30a3c8fc3ffeeb706d4d1a65604" => :sierra
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

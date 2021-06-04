class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.13.6.tar.gz"
  sha256 "48dfbb77b9193653e4e72df9633d2e0383b9b625a47060759668480fdf24fbd4"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0dfaf52bb836874183fd802837fb75ad3423a256da9d200d5b51687c86ec09a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "1163b83071c7f5896f7be18cc5bde3336e24df16b1b6fb1959084be94d299b31"
    sha256 cellar: :any_skip_relocation, catalina:      "1163b83071c7f5896f7be18cc5bde3336e24df16b1b6fb1959084be94d299b31"
    sha256 cellar: :any_skip_relocation, mojave:        "02aa2f947e229c522ecd5b26283ba326f039f3d5fbabf47d1c55d8bc8dc0d591"
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

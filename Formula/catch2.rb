class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.13.0.tar.gz"
  sha256 "4e6608d3fb0247e2aa988735bae2064381b0ec712f47beb766dd761838a546b6"
  license "BSL-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1966f0c495942d9b6bfa006edc14faf9da5659af2a0b2f5b27b1b65c0e8421e" => :catalina
    sha256 "e1966f0c495942d9b6bfa006edc14faf9da5659af2a0b2f5b27b1b65c0e8421e" => :mojave
    sha256 "e1966f0c495942d9b6bfa006edc14faf9da5659af2a0b2f5b27b1b65c0e8421e" => :high_sierra
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

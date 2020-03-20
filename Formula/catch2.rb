class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.11.3.tar.gz"
  sha256 "9a6967138062688f04374698fce4ce65908f907d8c0fe5dfe8dc33126bd46543"

  bottle do
    cellar :any_skip_relocation
    sha256 "22fce60a8e4291784e0bd44f424efb3cd6620097a72fe71d6b1aa3dadace1c41" => :catalina
    sha256 "22fce60a8e4291784e0bd44f424efb3cd6620097a72fe71d6b1aa3dadace1c41" => :mojave
    sha256 "22fce60a8e4291784e0bd44f424efb3cd6620097a72fe71d6b1aa3dadace1c41" => :high_sierra
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

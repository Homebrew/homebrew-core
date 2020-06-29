class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.12.3.tar.gz"
  sha256 "78425e7055cea5bad1ff8db7ea0d6dfc0722ece156be1ccf3597c15e674e6943"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4064b4dfc8aa9c26e720d829e57dd685f444f621b5f0ceb84c942d700b524a1" => :catalina
    sha256 "a4064b4dfc8aa9c26e720d829e57dd685f444f621b5f0ceb84c942d700b524a1" => :mojave
    sha256 "a4064b4dfc8aa9c26e720d829e57dd685f444f621b5f0ceb84c942d700b524a1" => :high_sierra
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

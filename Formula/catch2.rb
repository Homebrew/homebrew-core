class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.11.3.tar.gz"
  sha256 "9a6967138062688f04374698fce4ce65908f907d8c0fe5dfe8dc33126bd46543"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c573f4ffcb4ec4e9e98fecb0ac291373a8a0542cfb5c89a38149ad3bdb74b74" => :catalina
    sha256 "6c573f4ffcb4ec4e9e98fecb0ac291373a8a0542cfb5c89a38149ad3bdb74b74" => :mojave
    sha256 "6c573f4ffcb4ec4e9e98fecb0ac291373a8a0542cfb5c89a38149ad3bdb74b74" => :high_sierra
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

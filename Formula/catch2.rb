class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.13.0.tar.gz"
  sha256 "4e6608d3fb0247e2aa988735bae2064381b0ec712f47beb766dd761838a546b6"
  license "BSL-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7405839bc33f35be20565a1653bc112789d0ff0ba3daeff5e9846e1f80fc76f9" => :catalina
    sha256 "7405839bc33f35be20565a1653bc112789d0ff0ba3daeff5e9846e1f80fc76f9" => :mojave
    sha256 "6b886c94c3f56a9bd999eebf6140c7a62729fc9e8e4a110495f3e06d640abcf6" => :high_sierra
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

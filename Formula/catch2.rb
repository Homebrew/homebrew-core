class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.9.0.tar.gz"
  sha256 "00040cad9b6d6bb817ebd5853ff6dda23f9957153d8c4eedf85def0c9e787c42"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb349052b01bb04b3ab5a1adde84a72962d1ded5d11c36b96fbf205037bf6a9e" => :mojave
    sha256 "cb349052b01bb04b3ab5a1adde84a72962d1ded5d11c36b96fbf205037bf6a9e" => :high_sierra
    sha256 "768dab4bae91fb9729d61322217b08a2ebc972fe0c797b0a6017121a9ef0799e" => :sierra
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

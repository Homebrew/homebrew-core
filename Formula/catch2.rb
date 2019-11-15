class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.11.0.tar.gz"
  sha256 "b9957af46a04327d80833960ae51cf5e67765fd264389bd1e275294907f1a3e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "324a1c931fd1b5fa5d103004772cac80da644724ecca7fe9cad1cdbc6ae582bc" => :catalina
    sha256 "324a1c931fd1b5fa5d103004772cac80da644724ecca7fe9cad1cdbc6ae582bc" => :mojave
    sha256 "324a1c931fd1b5fa5d103004772cac80da644724ecca7fe9cad1cdbc6ae582bc" => :high_sierra
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

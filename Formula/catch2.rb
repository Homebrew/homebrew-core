class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.12.1.tar.gz"
  sha256 "e5635c082282ea518a8dd7ee89796c8026af8ea9068cd7402fb1615deacd91c3"

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

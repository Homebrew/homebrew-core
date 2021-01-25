class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.13.4.tar.gz"
  sha256 "e7eb70b3d0ac2ed7dcf14563ad808740c29e628edde99e973adad373a2b5e4df"
  license "BSL-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0edb0bd1f54ca94f52d83b34f01391d977f6e22d9b5edda6969b44f0acae3e2" => :big_sur
    sha256 "cc9b4a14e2dba8b4f2271bd376ef08c11d3046f3168f33bac63255cd1c3c73e4" => :arm64_big_sur
    sha256 "89905994724339d80de88e5fe043c59dda7fee37d608ed44d7c2d38233c44088" => :catalina
    sha256 "137c7fd141b94d0c206f0265b3fffbad55cc89c3db52249bd0921a64094576e3" => :mojave
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

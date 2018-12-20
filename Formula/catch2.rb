class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://discord.gg/4CWS9zD"
  url "https://github.com/catchorg/Catch2/archive/v2.5.0.tar.gz"
  sha256 "720c84d18f4dc9eb23379941df2054e7bcd5ff9c215e4d620f8533a130d128ae"
  head "https://github.com/catchorg/Catch2.git"
  depends_on "cmake" => :build

  def install
    inreplace "CMakeLists.txt", "{CMAKE_INSTALL_LIBDIR}/cmake/Catch2", "{CMAKE_INSTALL_DATADIR}/cmake/Catch2"
    system "cmake", "-Bbuild", ".", "-DBUILD_TESTING=OFF", *std_cmake_args
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define CATCH_CONFIG_MAIN
      #include <catch2/catch.hpp>
      unsigned int Factorial( unsigned int number ) {
          return number <= 1 ? number : Factorial(number-1)*number;
      }
      TEST_CASE( "Factorials are computed", "[factorial]" ) {
          REQUIRE( Factorial(1) == 1 );
          REQUIRE( Factorial(2) == 2 );
          REQUIRE( Factorial(3) == 6 );
          REQUIRE( Factorial(10) == 3628800 );
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-o", "test"
    system "./test"
  end
end

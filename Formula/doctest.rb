class Doctest < Formula
  desc "Feature-rich C++11/14/17/20 single-header testing framework"
  homepage "https://github.com/onqtam/doctest"
  url "https://github.com/onqtam/doctest/archive/2.4.4.tar.gz"
  sha256 "3bcb62ad316bf4230873a336fcc6eb6292116568a6e19ab8cdd37a1610773d70"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0d95b43cad7dfc8c6eb9675d507b2e40971b43e1a1fd74694f67b24b7d2b5b5e" => :big_sur
    sha256 "d6330d17be402aa04e954c776e694db4d3237237b41861b7259e8927ff795a90" => :arm64_big_sur
    sha256 "9d8136eca0f05e9f57fae2c1d6e6c3c3863dbd4950e0804d8ad5b712cd37a17f" => :catalina
    sha256 "e157bd83e738b90ea0b0f1a07a6ee70e25ea9f4f571e6062b561e1f974cf88fd" => :mojave
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
      #include <doctest/doctest.h>
      TEST_CASE("Basic") {
        int x = 1;
        SUBCASE("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SUBCASE("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end

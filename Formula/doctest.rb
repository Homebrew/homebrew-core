class Doctest < Formula
  desc "Feature-rich C++11/14/17/20 single-header testing framework"
  homepage "https://github.com/onqtam/doctest"
  url "https://github.com/onqtam/doctest/archive/2.4.4.tar.gz"
  sha256 "3bcb62ad316bf4230873a336fcc6eb6292116568a6e19ab8cdd37a1610773d70"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff3e085421ee6d980afcd33d0fb923576b2450e45bccfc9475291afd94415f59" => :big_sur
    sha256 "4d54d32811df2fc119a18704eb672df9dbfdc4562801f3571b69ed43a8a88101" => :arm64_big_sur
    sha256 "ec5730e02ee6da3f74d0b0b00542ad085cd9e0dab51403c9436ef5398846d499" => :catalina
    sha256 "5b6c590bb22dc1b1e31db08e70f0c253223af17b3565cd4f7b209bb4835ae0e6" => :mojave
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

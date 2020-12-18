class Doctest < Formula
  desc "Feature-rich C++11/14/17/20 single-header testing framework"
  homepage "https://github.com/onqtam/doctest"
  url "https://github.com/onqtam/doctest/archive/2.4.3.tar.gz"
  sha256 "18c0f87f526bf34bb595c2841a2f0f33b28ab8c817d7c71ed1ba4665815d9ef6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "aec633a80b86c10bccce7f9df197be13d6fefe7d793c6bb777e31eeb35b8812e" => :big_sur
    sha256 "d5e231785474716bec08870cdd7dc80d3fea61b9f2dcf5faaf608545895b031b" => :catalina
    sha256 "b75c6de8ce5002368ea7536c613a126e295a28d450716e325c1ca9fe264f3db5" => :mojave
    sha256 "fd8ad395282ece939e2ffe095bd5d8edf8d0e7602aa025bbdc4f62c6f7407d5c" => :high_sierra
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

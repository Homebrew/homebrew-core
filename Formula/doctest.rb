class Doctest < Formula
  desc "Feature-rich C++11/14/17/20 single-header testing framework"
  homepage "https://github.com/onqtam/doctest"
  url "https://github.com/onqtam/doctest/archive/2.4.6.tar.gz"
  sha256 "39110778e6baf373ef04342d7cb3fe35da104cb40769103e8a2f0035f5a5f1cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5271dde9d139e921ef3618dffa2475896123cfc9bb868cd9c1013d8fd66f8529"
    sha256 cellar: :any_skip_relocation, big_sur:       "48897cfd764b2b3b241c67a8aa8d6f0d203846fa42939a35b2de64e96aff5031"
    sha256 cellar: :any_skip_relocation, catalina:      "d72ed1e3e4f5897da6e9686cd048f38ad22307d0414b9cbc7496ca9d1f161c63"
    sha256 cellar: :any_skip_relocation, mojave:        "54e5a4919e7fb93c7eb8cf7001cccf0fc90cac50531138c3966d2c4174953283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2e9c84fbfb8698c529078bf132aef8686cc65931ea8f0ca86e0bc8e8e2317ef"
    sha256 cellar: :any_skip_relocation, all:           "da248b97f7c9829354a6dec9594ed7f1d636816ff1f9b04e0f1634ee04beafa4"
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

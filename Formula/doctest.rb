class Doctest < Formula
  desc "Feature-rich C++11/14/17/20 single-header testing framework"
  homepage "https://github.com/onqtam/doctest"
  url "https://github.com/onqtam/doctest/archive/2.4.5.tar.gz"
  sha256 "b76ece19f0e473e3afa5c545dbdce2dd70bfef98ed0f383443b2f9fd9f86d5b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9dc2fad76656c4da31728b79061374da37010829110a2c2f0a97763c2060a6b"
    sha256 cellar: :any_skip_relocation, big_sur:       "9953fc6b8a5f7c7b367f80ee18da68b866cf98cbd173f7d9e28cabc78f8cc7fb"
    sha256 cellar: :any_skip_relocation, catalina:      "b3b12c49b233e756e7cb8dc06befa73324c5b55692ea0adaf0b0635156a820b5"
    sha256 cellar: :any_skip_relocation, mojave:        "9b2183c34b14c5ecfc1fab142cf68d02454a39bd85d639e59caabd1df65e0fc8"
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

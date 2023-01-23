class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.3.0.tar.gz"
  sha256 "fe2f29a54ca775c2dd04bb97ffb79d398e6210e3caa174348b5cd3b7e4ca887d"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ee8ebf7afb6d424be1d0bc03be1a4a829770279d6537ba1a77945d78e27d07c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08fba72706dcc36e0bfea96931aef1045942c86a0ee8fd66412bb0a8028cd976"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d82d4019cc987c28ddfa28e69e0877ca1e467e8405ecc1b113b6b237b54c26d0"
    sha256 cellar: :any_skip_relocation, ventura:        "70c3ef816f8ff36c2fd47664d749242f039b5a2c5a749b3c4e26553f90758075"
    sha256 cellar: :any_skip_relocation, monterey:       "02a62b258d0aaa7fa3b3b7a176a6b7957ff2870004647114ab3c9b9a4bc4fcdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "bde5f049757d9d4eee8e93c3595e911b2a88bb055ecd3734c8436604df2c1306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5310c4bb81932681cc5b7ece48b55053f5ca51c20a1e29358ef5b7e0dc6346a1"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <catch2/catch_all.hpp>
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
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lCatch2Main", "-lCatch2", "-o", "test"
    system "./test"
  end
end

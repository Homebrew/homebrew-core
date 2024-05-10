class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "485932259a75c7c6b72d4b874242c489ea5155d17efa345eb8cc72159f49f356"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1253b00f8ffc08d69b220ac29f59dcc53910a7c354c5ac6c6fc3eb8928be342c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3662a52f668c9bd632fe1729504d1d7f98c49e77cfb17251afb866044a460e98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e795725683ac575fba10d8493a3442035e892e529713a50a3cc257198a0903f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "126d691236e518dcfe0e87a5c4f079f10da0287e44b4977a27d0314703915b98"
    sha256 cellar: :any_skip_relocation, ventura:        "60d17b8064ac6b0beb6bd274a67265d3f104a2f7ecfc4e3370e9c2d0df9b13e8"
    sha256 cellar: :any_skip_relocation, monterey:       "9d3b11a912656af116a2d3c9ed6af35575055a07f0e6f8edd1d3397d288ce079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52b65db72407b07e9a617f1671546c2b4419665801b3ad28398df368631d2ae5"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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

class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.16.1.tar.gz"
  sha256 "d16bd1b8b2364918bd472cb216394acb93bde6784890df0d91bccfb3f28d777d"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7472a6ebbad97831aff9491feaa8d6c5e0ffd76f1e4d90065edbe61f090fb567"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ded57838aa5d229e305adb3b7ada65e31697bca51607ee9ae1943c45822ddd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "549dfe4e066817d3467b7c39df4112015e8a1c81d9b2008efef134400875dbbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dcaed6d498c6d708ba770d3e84c5a03d186fd7eee71f956252c5b98be332bb86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9468f1be79a71a7d1ddaed94e780595f569d0e91e08edb86a24ef7cf151e40a5"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lCatch2Main", "-lCatch2", "-o", "test"
    system "./test"
  end
end

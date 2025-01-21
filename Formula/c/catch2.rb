class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "1ab2de20460d4641553addfdfe6acd4109d871d5531f8f519a52ea4926303087"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "591ec46514fc1c4e1934b8be1e8592d376864ae7a9f1a0de46c266795b6b98af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba90a4079821a6246f5a9fa302e1b8a5f61eef26732f178913372a8bc2db0eab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d02f3e55951c66fbd0326dddfee7abcec3de50c659de20adc33319784a0e713e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3768de93034cb1c80114c107a828e0664affe03c0d6062104e8f9876c9c48154"
    sha256 cellar: :any_skip_relocation, ventura:       "1635617308a7b44e6a6c0f9abfda0a5c0ef6d16259333d6b87ceb9092b5c1381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fddf61b46104e66518b774a67afc1ec16167ffe9cb52d514e2e37fe72d58b3a1"
  end

  depends_on "cmake" => :build

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

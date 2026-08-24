class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.15.3.tar.gz"
  sha256 "b0299ae552918220a7a6e21e7de5b714777f4e8c883fb70c4bb23fe01df8c6e3"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3109c5326c756a4a5d89cd8076f6ba7db18e17da88281009fc207e5a6137989"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fd63352b291f2bc879cb3f639ffc58fab8ba172d8d2bd3f8b576f252d9c5695"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e9f0d96ff1207ca04c45d94777179cea2cc27eb3d908426146ab3a9aefbda29"
    sha256 cellar: :any_skip_relocation, sonoma:        "2680a04726a05af1f32b00e517724c18613834392d1e212f839f1891e248712b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffe9ffceecf9401710f4ccde65376973ce876ef524e560de8af77cd4d2abd555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "744e13a1b0c407257efc04d8090a0c934cbd41ab79cf407494875c48f4216cb5"
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

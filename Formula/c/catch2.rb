class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "9650c55e497759cc39b977e45524bc8acb15256061c112080916ab6cb0b1ea66"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c92206feb2a389c32f3949d844a3105b2b1f46968a49d351b1383e423a0db051"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0720c225534efbfcbf20c0531012d7256eb8fe26c7c514bba6e2d8fcd97795ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ea8f57fc5876fc50486478c5bd27029899120babe0ca4ffe20ccd635de77e1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad879c048656cdb4d9e7fc4bbd99ba6987a8c760d00385218534089f9eecd168"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "820786aea3fbe36d85cb479ee7190c1d785e6b599a0751249a00d8a670b2afce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a65b2724560568f65a3347d4cf033311f228b079452763ddececb781333096b3"
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

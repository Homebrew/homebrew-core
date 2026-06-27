class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.15.1.tar.gz"
  sha256 "be23a52b85cf04cd9587612147a10b023d59ed9757fa1843cc99e615d6c0893c"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afa4627a6296e58c6fad7437c2b386ec3d1c99934f84507d5735a8f0b5ee32a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49aec47f88237d3721f6a441aad7fbce4c6d2e23569feaa0406b8aab383824b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f88232406903a5e0fbf27894f76ff15437e97f3f36a2125d0dee955ecf05849f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e63a2daca556d3e6c640c850cc3e0ed46d90519de3fe3d43031b65c5cc680fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "482bd29bddc2a27f39e501a97b3ff2a46092e3b10d36d062e2c56780cae89811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30edf1d7c906ceb9c605e89c239033db6f8dd4ac88807bb908dc650de29ffeaf"
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

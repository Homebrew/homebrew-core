class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "18b3f70ac80fccc340d8c6ff0f339b2ae64944782f8d2fca2bd705cf47cadb79"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79e132019cd20543b609b41c78bda19576adc6de2f523f5d50528813209daa78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b89254a957d82d388a96a3d3217182c767cfab788d86b704055dd7afd3f57ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f279dc10ab81e414fb9590ffe74e149f3731cb5b835df69069fd7a5f7b555c79"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d819d75133e26e6c58ea5c34e4aff0968841d7e6e977c7f2fc89ed25417d794"
    sha256 cellar: :any_skip_relocation, ventura:       "05e195d8f2ccead1f25d72fe8642a5dcab8b36d2be7c820eb43d745375139cb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17138f43947287169ce009e66619625eafc831962754788404b33de42984672f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "945bdaaab135af5a8646c2099c4a3f7cc8848e2d837b2dec89434106a2ddd0dd"
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

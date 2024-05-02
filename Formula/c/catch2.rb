class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "b7754b711242c167d8f60b890695347f90a1ebc95949a045385114165d606dbb"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ccde6cac609c43d76808c41ffe57452f78cb1c8fca783a04f8e98c0f2cac3e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69212712260b5d2cc841c4e2a9ac7f4e0ca00ebe30cf8f6cbcbed7362af2f539"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "690c3e96abad82cd6f3de1fa612710b1a71e9e97f32a7b9ec6c0c0534378b2ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2a8da7a74064f9c236d9e132ccc1e4e3c6ffa6fd859b52873571ea61d741d45"
    sha256 cellar: :any_skip_relocation, ventura:        "7c791788a77739df2f633285fee54671b891e7cd094e115907afa08c212c22e3"
    sha256 cellar: :any_skip_relocation, monterey:       "c7ab1b8ffeb8dcd72b555e2fd58ea580b219ad06746c383c56164128f485f37d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71843e185931866d4ec919b56b17ce72ae0291f4306014fa61365d3b0019713c"
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

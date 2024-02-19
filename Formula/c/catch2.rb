class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "269543a49eb76f40b3f93ff231d4c24c27a7e16c90e47d2e45bcc564de470c6e"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb2c4eededf9771db5683e0015cdd17a15eeb201a6c4240897f61a08254dfdb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66cafcb42af8b4f47b5610567203b76f81d7e3a8afb8bcdfaa8f6275922ab13b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "153377c5960c83cb19b5f91f41ea4917510f7a63e1af6503d7dbaf35bc5644d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c66fd7745c3aa1742d3dbe8fc8cf57afed433449c77b004ffbed06884073692"
    sha256 cellar: :any_skip_relocation, ventura:        "8b0c206405a6148f83b5733d03b8aa536e2aa9ed386ec638759abcfdc73f4321"
    sha256 cellar: :any_skip_relocation, monterey:       "5a1bab55c1da1c4c80910a8ecadb34a93c4f8acfec0530aa4c8dcd601f2a600c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8baa3698ff1ee8fbd285866cd725a60289af8b211b98dcc3b47a2769557003d"
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

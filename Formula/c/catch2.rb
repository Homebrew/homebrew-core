class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "650795f6501af514f806e78c554729847b98db6935e69076f36bb03ed2e985ef"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ece311edb2ae65de9224e579597eca0ea7fdf77945df496810eb89f923271326"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f5b1e2a2523026bc04cee55972a0161db22eaaf65de12bc297a7d8956667267"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d6aa2ffc9bebb1fe37c430f195348217736a06887c907c92072a6e0a1b5e51"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc4a77abe14e7c1398f3c7113b590d768c158f9e323f74676f3b8164d2323719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b2aaf48545afddf324378906d4e840c7ebed8990adb07f898b12f29e0fc041d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade355fe90ce4cf9f241d8a22e9465c49e6e773d1193f25a97225acf586234a8"
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

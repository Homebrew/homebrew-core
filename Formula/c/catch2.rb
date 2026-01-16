class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "e077079f214afc99fee940d91c14cf1a8c1d378212226bb9f50efff75fe07b23"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b13cf12aaf6f042e3b8ff03cd8b077b0a99b71839279b5680700e23f2df448ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ed164ea1feafec260099d30872d26f0e5a3cea4c8500ec1d3939ac6d42ed2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfaf8ffcc95ad3d96069ba8ed4be3130a76e8f0f42f02efb5f3fce484f45df0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f7e505bf8e08f21ddd5c298c48286415c6cf16d602421a6e47dab80a1259f6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58c37a22399463bb03beaf6ab7c63bf30bde04e4842fc9524a1a4eeba745f3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9768cbbc9dc84eb493756b11b6f851b85cd1fcc099549c4be9167b6f92f446d0"
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

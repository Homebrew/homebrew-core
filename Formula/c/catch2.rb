class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "ba2a939efead3c833c499cf487e185762f419a71d30158cd1b43c6079c586490"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c8bc214f97cd097ec83e7b7be8adc21f69721f65e9410f7cf592514af4483a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9deb2f25a3b8ddc70a48b32cbe4978a549ad189f8c995858aa1fef1dfa68e799"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f31174e19ebae246f197b7ab4cae3f923fefc8440b42991f5e4b39ecd94f8f6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b613bb8ebd7618ca39d2d1da1ce46dffc605584691e211a45a2ec38a26caaf80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5add4083aee85ed103f4ffeb3ae8476510891f2f185338192c79f5dfb8a54b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27a05ddf677e774bf10c69fd7eba7b1b700710f3fb515fe7ecdea3c1ba95acfc"
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

class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.15.2.tar.gz"
  sha256 "acfae120892c2b67a74142d36d060c0caa96f1c3aaa8aabd96e19961163d0420"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9bb03540bdf352bec1ad7f3f09cf82cb37a627a4ced0e9085ed280560bef8b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e54dbd530b5eb98d6b2d96e1e40d4b53a2401b6e6beb0780ba3bcdaad9babf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "773768c84250681d553100f200fb1f956de58588790aae0c578fca86866a4524"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d6a6def3ee39e67673032796da9e15cae2649b132a32187c0be0da7a14df997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "085cf7958d634c8368bc6d4b6c7ff7583a7c506995dbdd025d18c8f08bf54eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ecfa2e9c72fa10c7ae5a8bc4d944d5805e069cc5655703c521ece3dd3827f29"
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

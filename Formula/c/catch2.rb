class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "f6d4f8d78a9b59ec72a81d49f58d18eb317372ac07f8d9432710a079e69fd66a"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "653c3f6e5ccaa77a6d350dbebec98a3dee8ae4f3e3f280017b09d5015fe26271"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aab6dc9ea42a1035d5f715a6c527eb7b6ccdcc71aa803ccb736f847223522d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73e3addd99166aa093b18a786260be831f847d1dc9a87deba714aad13939f0e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "254bc0e9d016113795d5e9c45408b8666b54a8b301b83017f3955b6849283312"
    sha256 cellar: :any_skip_relocation, ventura:        "539a866f3bc6b729d9ea14601f8363eecba689be64f600576d2324740679ac4c"
    sha256 cellar: :any_skip_relocation, monterey:       "f8139e4b428e21cc480d4f226842d3595489c293c7d10bbdc4bd04cb90c12a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bde72ca2ea251d095ec20cc8b8e3da9fcc061b49a632ce0339ee3d0dc093175"
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

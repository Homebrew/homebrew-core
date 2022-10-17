class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.1.1.tar.gz"
  sha256 "0708ec9a20bfb1f48bf794e7c548f65bf17987f71a786ba8210d1a479e2491b5"
  license "BSL-1.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b07f3763a2b490e635e522921ce46bf394630cc890cc3c25eefbfbc7916b3a9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1bfdeee516c57508fc966f8c8e597ac3027d14f15c8a66ee3c34f246a041170"
    sha256 cellar: :any_skip_relocation, monterey:       "d2933b99b16a54f70c41b93187b3e832f24b5a98ebf0034162dac506611eb992"
    sha256 cellar: :any_skip_relocation, big_sur:        "58efdf7d1cee6b5bfb3d641b20a4387dc7cf09c451dca4b170766d762a9d39e1"
    sha256 cellar: :any_skip_relocation, catalina:       "0922e33d2d012d83970787e66af3f497490c31f3ba3f935b6a1f793fd82b284d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a2beac4f21835c7d8178c0aeabc0931fe7328bc64b086d0a329c6be458737ae"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
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

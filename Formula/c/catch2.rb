class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "8d723b0535c94860ef8cf6231580fa47d67a3416757ecb10639e40d748ab6c71"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00f1b93db464da30704c0dadd8987d45642fa495d31cf5b2d1ea74c6926d60b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83ee5b3680cd50636063ba578b33982f5892641f7780b78dce9fbbbad7992f20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13ebc5823148acc714bb90e27439d855d4ba9258d0da573f86caf5ffed03112e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fd8767200651c3df554803110ed5a879e53c1a80424e1a1f2621cd8c24b4669"
    sha256 cellar: :any_skip_relocation, ventura:        "7191e2d05144356d70572312cb72940d4298f4d7bcbbaeceefae994e979f255b"
    sha256 cellar: :any_skip_relocation, monterey:       "a8120d9c3537a102bc4606ab244ba93a242e2ea066fe73a67c1eb48642ece28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "066ff25030abdfc1de4826f6d6f10d29810b0a5778aee25cd202ddbb57996b58"
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

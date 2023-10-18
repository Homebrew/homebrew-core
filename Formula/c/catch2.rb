class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.4.0.tar.gz"
  sha256 "122928b814b75717316c71af69bd2b43387643ba076a6ec16e7882bfb2dfacbb"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fe1ac27006ee16908788300add94e826029194323cf2cdeb8d390e9a7b0575d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c956e6e447bc9790b622938ccebe9666002a518c895350c74933d6e17b5411c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "debe0963dc1029c37e56e7b879e1f03db0917c5d23ea5e2f38de90af807b04d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64c7c05a1689598948d9568e76928be2288775e205010bbb93c95239f3c2da78"
    sha256 cellar: :any_skip_relocation, sonoma:         "993d669aedf1e4ba6a886c51b80893589882f75b50b260b23e9b249400b5292d"
    sha256 cellar: :any_skip_relocation, ventura:        "0ffe7b55d16a8feae978ae744c1ae20d93769afca28c10b1ceac62f7d0927a12"
    sha256 cellar: :any_skip_relocation, monterey:       "0fb84a4ff56a56e204b5642fb2b580f6fe1bca7b412b10c90f5d4801783cd3b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ed1399fe4b4f1802ec837332711d529577f0da21b88b24c8e5bff5294ffa448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e9277218364ed7c1db8724387359d14a0abfad2a98831103570cc7cbf84758a"
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

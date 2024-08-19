class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "5b10cd536fa3818112a82820ce0787bd9f2a906c618429e7c4dea639983c8e88"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e989fb335f09b75b0689a44d90e72ec074f1eb88fb86cab2bd5e6eb5519e615e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ee178fc874cbabe0d78fde8212b3b8920eea870b16b712883e65d4e0a4ae01a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e61015751aed854f4d21cfcd7b1f97e9e6624fd4cb19e03ef421f7a1af55657"
    sha256 cellar: :any_skip_relocation, sonoma:         "69719fb16a29f27f0dcf7fa21e2d3f39d76326447139b50667a5c76c2ab30b88"
    sha256 cellar: :any_skip_relocation, ventura:        "58581cb367f7f3366432503fdcea5554e48df9dda67c6e569725e04b9b045178"
    sha256 cellar: :any_skip_relocation, monterey:       "87529e95e17e8af9c5f106c196cc91e8d5e85d3e4f782e3c5993ca57b666382e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d2e562aa0967331a34e8f52d9196d7b07a761f5f9e46201a0fe3ca269b231c"
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

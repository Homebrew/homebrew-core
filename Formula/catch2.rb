class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.3.2.tar.gz"
  sha256 "8361907f4d9bff3ae7c1edb027f813659f793053c99b67837a0c0375f065bae2"
  license "BSL-1.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8d0e51ee2f9522ac93fcc5693004dc90474f507ca08ce01483b00d5f5e65c61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d56e29c74d3da754b8d5690995cb3e100e2202934be795b51aea4db9605165b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2d8f335ca14ee64987dedb7ac200d820b9c61e7255482b2c4b3b0e5dace2b4f"
    sha256 cellar: :any_skip_relocation, ventura:        "7d42b219a5d9fc1008f1385a23ae52a47f5bf67cbefd526a71f795e797f84d25"
    sha256 cellar: :any_skip_relocation, monterey:       "3c4eea1374ffa26f3117b4ca48f5d3126bcca08441aaddf5cda4085bbc34409c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d4ec3ddd321176a4c6a062f4862eb51510d37b585d9438b65ea3d8c2a87da56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c29405a8638ef96696b9fd2351551f6c07d6502660c057be8d183f6df0fe6b05"
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

class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.0.1.tar.gz"
  sha256 "8c4173c68ae7da1b5b505194a0c2d6f1b2aef4ec1e3e7463bde451f26bbaf4e7"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c391abecbf8f2794b8365ab46f14f50469593e307bbc3a20d615fb79304b20ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f64cc7402e35a668b4b85101443c555145cba6e922c33120cfdaf7bbdd7666f5"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef2c771a61e5f114dba5a6342bd01cde956b9c055cfd764a5bb0764763f0622"
    sha256 cellar: :any_skip_relocation, big_sur:        "f683d29973220f5982f30f969da569624e1358bb7166fa27ffc69ee71cbe0ed9"
    sha256 cellar: :any_skip_relocation, catalina:       "194f0045df5d29fd739930562f4ed2d3f9c000076f1d9e8f8ff2029f67c7cd7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffdcf88c50ca418402e47bae17775334d1c39a9b58830c1421d007e13dac2202"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

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

class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.3.2.tar.gz"
  sha256 "8361907f4d9bff3ae7c1edb027f813659f793053c99b67837a0c0375f065bae2"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c8ccb00b31d4487c3ffc37b837633d7744cd2f96b9352949724e1edfc4a13f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a77947dc25d84ca801a9555648ce9880ce8310736dcecc50d699099209733e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7775c69ac55a7fbc92177da1ec74a82fc853f4b9ae62f2aa7e344df8f9e0bf97"
    sha256 cellar: :any_skip_relocation, ventura:        "ebdc23b99f2d433b062a420aed31f50c3e3931fa30fd21bb60e302abf081db00"
    sha256 cellar: :any_skip_relocation, monterey:       "913827abc63b84feb56b8fe344e51cd8d10d7440d6a6e4eaa44613f65e7e14ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "89f2de57a604984888823d9ccb35f01fbcbd8a517e618163994c5d03c593949d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8189377ccd83886abf1e15ff3f1db940ca42f1d14e0d5e1129450a7565bf1d97"
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

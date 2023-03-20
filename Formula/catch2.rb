class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.3.2.tar.gz"
  sha256 "8361907f4d9bff3ae7c1edb027f813659f793053c99b67837a0c0375f065bae2"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15f5edc179c4627d31eb25a0628eaa7b9d6807afb874e363a1fc6e6ae7161146"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdc9171cd7d1f78de34a24198987227de6e1e6990f63ad6062f023b8cd2e984a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f37e7ddecc17a7107591174f3352b4f5aa45a48302f344b211982516255aeee"
    sha256 cellar: :any_skip_relocation, ventura:        "c0fe0bb14f91032ddc90536277c53a128063b722f6ee9bef3a172ede7dd69a6a"
    sha256 cellar: :any_skip_relocation, monterey:       "2fc451692500a6b53f07266abc14c6a6560e2d7b1cda4f2686f951c4296a46c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "af6936b0349e3d88dfa8f9c3589f0cabc8ec5a29225ec89dab7d67c0bc77fcb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca1b233b4a688a9d20edf2df43065fa4338b3789b29c5ca60792be2689603afe"
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

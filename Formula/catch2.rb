class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.13.5.tar.gz"
  sha256 "7fee7d643599d10680bfd482799709f14ed282a8b7db82f54ec75ec9af32fa76"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e43b3746d468730f54caf08ffe0b633e69300e2842d137b0c9f751881c9e89eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "18d1daf9fb4bc46595060bdbc562a0e147a5756bc3cc81d81b798e5b0ddc9a9c"
    sha256 cellar: :any_skip_relocation, catalina:      "f583c226f1a55f77de8431bf240dbac790a51e9cd250a565309121c79bcce716"
    sha256 cellar: :any_skip_relocation, mojave:        "e4792c34d99cf8efe70592b25fd9987f07d3aeb7fc5c3106d8115899e143427b"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define CATCH_CONFIG_MAIN
      #include <catch2/catch.hpp>
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
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end

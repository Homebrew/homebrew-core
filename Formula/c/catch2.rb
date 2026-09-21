class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "0957cae5821b17ce07f0833aaa52b5137643a8382203221f363a8303c109af34"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b630dd3f854fe75dfc4b456801d617bede2657234772e6f9d99232c8aabe34c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "63aef74b3fc0dcc2eaf066f8aa12b254644f86c86f1c3bb71b781efd33c8219b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49b17bb5e16f99963c5a2393e77e60747c84ae312e52a8ff124383043ae9b45c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "289b46efa400a94e710444d1e19d2fdeb2db37b6c5caf1be4f058f616df4cf01"
    sha256 cellar: :any_skip_relocation, sonoma:            "ce86498bf15a964f3d6800232359c0e3a5b43f827230fa63d2598b47d2008ee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe4966c61dc34233c6927803beb902a5fa85dfbd7149fe1c480143803134c97e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "adcbe742d0e4b16188fb3213f35bba6073611e0c9677b033821dc9fab3809a29"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lCatch2Main", "-lCatch2", "-o", "test"
    system "./test"
  end
end

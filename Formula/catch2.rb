class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.2.0.tar.gz"
  sha256 "feee04647e28ac3cbeff46cb42abc8ee2d8d5f646d36e3fb3ba274b8c69a58ea"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bf9e27b974e7d708bbb6735406b222cf0226c620c546a83d69976adea4720b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdb910cbbfff1e17b8f50aece313f14f51723309a2ba5dac2705922482df0b3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0594e9eedd28cee43dbd68fb094a64c64cf4c62ec152cb90352fd38e0a2a1a2"
    sha256 cellar: :any_skip_relocation, ventura:        "e5b1de3464dae23d480a05c7056e4ee2a9bf8676292f448966cd396132fc91f0"
    sha256 cellar: :any_skip_relocation, monterey:       "bd0080d2f8dc23961dc19698e2b86ed02d72ad8084649e66433221c7c66a7d6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd5f9a443e018a9af01ad1bb4971800eee26274cdfe3f3d1bdd2686c4f92a07d"
    sha256 cellar: :any_skip_relocation, catalina:       "4fe943290a551a890806508662dab78d2a49bb7a85322ea1c0cc913e26ed73e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93fe2a2598faaeefd7dc6e991f52b1a3c3aaabab229f63aab0cb704a17bf3d9c"
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

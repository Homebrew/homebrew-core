class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "82fa1cb59dc28bab220935923f7469b997b259eb192fb9355db62da03c2a3137"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46eb4e040fc26befc55bd5b963b74cff2ce5c1290724eb72be40c8ec7cd362b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "997ca95ba0337e4caf13577c3cc81624380b3c6f8ec8c4fdc539fa1ecc22064d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbe41f2586b2426e9c21e309a4f5a11ee3abf89d9ecdc5daac2bb8de758fcf04"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad3dd63a7d71ed3153303d746b01f93f907135c85678ca17f7ac467834dec835"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df57def370f1002bdbc57528222d5b2c6fe8f052fb3b4b9cde2d1d01c7c225de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10df67fe223b619f21e68f12202d006fb7fb192a52a3fbf43af5ec52a5acbc65"
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

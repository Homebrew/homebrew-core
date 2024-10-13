class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "c991b247a1a0d7bb9c39aa35faf0fe9e19764213f28ffba3109388e62ee0269c"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b63c2bff461b22383d01e8edc201f50e7ecbd0590d8d0d8b3d1c481ca3c297f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c4ee228d315ab1a4aa7525d4188b9b04d3ff46bd336482c6c41b3c93b3b1c01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc7f77824fc4be0a1e4597a527f869a4d6383e543569ae79bbc726b9064f1fdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfca1a1c225a52d2201b07b63376da26d7e50d2132c5a3ca327211ead70610cd"
    sha256 cellar: :any_skip_relocation, ventura:       "351b8571546a1fd599ae3f66d974197cb38971bfb3ef62d5a516a2540dc93506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "992f7bf0a61606f7533bf930c9bfd1a03089ff63eb0982e445c8e70f7d095b59"
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

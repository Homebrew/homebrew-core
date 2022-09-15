class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.1.0.tar.gz"
  sha256 "c252b2d9537e18046d8b82535069d2567f77043f8e644acf9a9fffc22ea6e6f7"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b9ce5308bb0b13ccfbcab646920dc17121211db32cd3a577018ac3d2a695516"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7cba304887532a66493a58513846535498ffb644081ffbc200140da0b8b1954"
    sha256 cellar: :any_skip_relocation, monterey:       "6b9e8aa37c5857a54825ff19f91ef46d718460effc65b5b221cefa9f4a4916cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "43bc615a8e21ec01865789eacfdc5e7a2022da763a6fee3305e6e8b1f92f2cc4"
    sha256 cellar: :any_skip_relocation, catalina:       "964a4a5179b8609022002ddf2e399f48a2f989f15d12e59ab5600ceb82fb77c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb1753a64cce0dd3c5266824a8343f9c167f82605f2d380f0ff73e2a253216aa"
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

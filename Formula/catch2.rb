class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.1.1.tar.gz"
  sha256 "0708ec9a20bfb1f48bf794e7c548f65bf17987f71a786ba8210d1a479e2491b5"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d08d118313865cf5920e3fc27f1907891ac78ec4b129e42ba9190704b8029ba0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c97e1c2aba9ef2e87d35e14a2bf0ede6a48547f6858442e6ee0b72db9202a1dd"
    sha256 cellar: :any_skip_relocation, monterey:       "f6899222c3a1a90b15be147932609acb45fb8c79813516ffd746d3d68ed9de39"
    sha256 cellar: :any_skip_relocation, big_sur:        "26849060c5a91a5cd66d1f1531b159674164a3b33367dc7b11d1efbd41f97a7e"
    sha256 cellar: :any_skip_relocation, catalina:       "2c5d60aeb2d343e0485f48386c767592e2d21bab8b022ecedb39de2a088f58bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9f9812f4d91d9b9c7608422a71080437d487a063df94038342bde742bd6933f"
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

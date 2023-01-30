class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.3.1.tar.gz"
  sha256 "d90351cdc55421f640c553cfc0875a8c834428679444e8062e9187d05b18aace"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "154b26dd4c2c70c2b046ed7a5e80f5e50923d2a402b11ec15ee34dc1b14dfdfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10c188bd6c92efbe3e9390a6fa56cbc09397a3de0c5fc4c326d4fb77f55b99fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1d476a1d9480d8649a10f727210b02a9fae33832fc6dd035e851c1e583c7da6"
    sha256 cellar: :any_skip_relocation, ventura:        "ab553465654371f0fef62c06020fd7c498a26a67a8287efe2b6ba1f28119ef82"
    sha256 cellar: :any_skip_relocation, monterey:       "4119516f1a1808db4ae9befa53d4afd4ba6999ad9f3847bf443f21d6ad3b76a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "68a4ae0fdac56037a78c3c34222ac2749a5d0fa2de8573f8e5bbe1c0727c16ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf0cdda35dd5acfdba03d6c5c2be3c299ed975cbd6c1ce13f043f4219274ecde"
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

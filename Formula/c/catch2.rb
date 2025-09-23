class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "fc4303a5c2738beaa727066e126b5a28837a812230a3c5826caa38e7ab99ca48"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de3d0740dd8a59c88b5b179cbd4b20b849cbe58cdaac32d160fe279e55315e6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9605060157e1be122a5a9fce752c043f4f0c2cc71a3c2f4c2c54378256cf44b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2693c5116180538554910f33585e1afb47425ba859b7898855453ff03a69788"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "334638b7b03693d583e69d094332101d26ab0853d391fd225c360bd04f72ffc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a58a8dc7a5526635a093ba594714d0dd386f6e92c3cc4e48999ae08cb90a3d9"
    sha256 cellar: :any_skip_relocation, ventura:       "39bdfda6fde663b57757ab606a4c63ec8b1adc7bc24e727dc15630985b30fc80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "825898be34d1ba71dfa5a6743cd49562e99fed02158b7e56c40e56cbe9058a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c4b1f689de7d9c6c78bb6d3ef7c09bf8e4ee90175785abb1593e7ac5db69d42"
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

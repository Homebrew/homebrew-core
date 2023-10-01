class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/v1.14.0.tar.gz"
  sha256 "8ad598c73ad796e0d8280b082cebd82a630d73e73cd3c70057938a6501bba5d7"
  license "BSD-3-Clause"
  head "https://github.com/google/googletest.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54da06f38b6d3249c84b52b2da8fb6dbd1dd107d2a13b6b8a3d3d940253719f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d403b2674150b89edac42559c20e9f578f2a9bee497ad669a50b32ee28a534d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "115017b85183ca9378ecce82eee8cb18f0796c348eee6fce94db2be9674bafe4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a4d7e9f9d4168c6f37ebf77f9b35d6053cbe958661efc558ebd755b93600bf9"
    sha256 cellar: :any_skip_relocation, sonoma:         "df2342cf8f73db950345b67e2b857e9e46b57e6b1f341329a30622588f08b5ff"
    sha256 cellar: :any_skip_relocation, ventura:        "3ad31b4bd6cd7dd49035daf80ce0a44da474e08eb0219d5e96bea3096ea457b0"
    sha256 cellar: :any_skip_relocation, monterey:       "355a12ac8f19144f1ce72fb70ff3af5f84db07c7ca0dd4d24d8a949f2d3f555f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b066751100985e0d98294e3f62ef06e6ffbaaf540dd35e801bc49de8fa3ec88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e909135b2c392247376ea875a6e0b35c3476c34a8975a3e5f78a8c93a1ecc253"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
      "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # for use case like `#include "googletest/googletest/src/gtest-all.cc"`
    (include/"googlemock/googlemock/src").install Dir["googlemock/src/*"]
    (include/"googletest/googletest/src").install Dir["googletest/src/*"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <string_view>
      #include <vector>
      #include <gtest/gtest.h>
      #include <gtest/gtest-death-test.h>
      #include "gmock/gmock.h"

      TEST(Simple, Boolean)
      {
        ASSERT_TRUE(true);
      }
      TEST(Simple, Cpp17StringView)
      {
        const char* c = "test";
        std::string s{c};
        std::string_view sv{s};
        std::vector<std::string_view> vsv{sv};
        EXPECT_EQ(sv, s);
        EXPECT_EQ(sv, s.c_str());
        EXPECT_EQ(sv, "test");
        EXPECT_THAT(vsv, testing::ElementsAre("test"));
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lgtest", "-lgtest_main", "-pthread", "-o", "test"
    system "./test"
  end
end

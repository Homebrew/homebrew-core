class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "7b42b4d6ed48810c5362c265a17faebe90dc2373c885e5216439d37927f02926"
  license "BSD-3-Clause"
  head "https://github.com/google/googletest.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "075aca662eb811a15c54953f21a500c22d445a652ad998d8fcfbf91228d4c6ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6ba5c5f2cd22dfcd0e81678c94a7d2b570d5aca9eb0c28c744dffc4f60ed488"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6d8ab0b37f041319aaf99101b2db99fee3e4ec43d760f21c41537395465c228"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d3ff95b092a34fffe8bf2b181c16e3fd0697607e8cbee65a9f6ced56039ac4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5e7fb287f2630dd9cff6d8b64faa2d802f9a342b43e1869c45329f525ce5cfe"
    sha256 cellar: :any_skip_relocation, ventura:        "c099292776556392724ea5b8b0feebf0f98c7832cd7d2696132dd583d1b77824"
    sha256 cellar: :any_skip_relocation, monterey:       "28d274beb73e1784554ea5a427e34e89adebcf0aed36ae2767dd6bc9cb0d99d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "353bdf4af061388cf88bcdd3181704400bf6fc07b3fc16530669e09cec72c5cb"
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

class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://google.github.io/googletest/"
  url "https://github.com/google/googletest/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "6e3191c1455468b3fc35a417fb565c1c5071aee1b7e7f85e30cf48a98d37d8b5"
  license "BSD-3-Clause"
  head "https://github.com/google/googletest.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84c802723cf6c5bfb825a5171af335dea006f92bed799508160e4c5cfe7d00fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6665ea2968f21ab0c09ce9e82c53b41aec24283b239a44fa72f3574be1ab7815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e224ae3b03f3919b867943f12e7df93bf17621a71b0d1abee35573d8e71af4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdde122b743749f4db6a7cf2424a71856ad09db51a950dadad9c8dcc7bbacb14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c11e7502c1d8b89703cf24b8439e7c69be4a28c76d6bcc762c7b2fbbf8c8c310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1f9c006572fda7fd19c2c4592c0ba8dc80ec23053ee3fc7514587187f4fe1aa"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # for use case like `#include "googletest/googletest/src/gtest-all.cc"`
    (include/"googlemock/googlemock/src").install Dir["googlemock/src/*"]
    (include/"googletest/googletest/src").install Dir["googletest/src/*"]
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lgtest", "-lgtest_main", "-pthread", "-o", "test"
    system "./test"
  end
end

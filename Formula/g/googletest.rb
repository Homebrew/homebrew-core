class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://google.github.io/googletest/"
  url "https://github.com/google/googletest/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "78c676fc63881529bf97bf9d45948d905a66833fbfa5318ea2cd7478cb98f399"
  license "BSD-3-Clause"
  head "https://github.com/google/googletest.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "190d3bd68d4bf26da5f36dc32e88011643e84aef8196edebbbcbf757d08d2c2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a6de6e806ca44915576aafb65d50d1b58ab4f337560a02c8780a3b9fe8c1010"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ef1cc29975aac943340518a6057af030da284f73cc6122fa6bc1127bfc8d5e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "71bf77319c7b3c51b22f28cb3a91f833ea89dec750fbb76a45827d6f834ac56e"
    sha256 cellar: :any_skip_relocation, ventura:       "146609ea00020a57519b405cfa3e0247aad824fd83779190af4bd6d1f9fd7067"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "320717b24155c70f960a6a9eddef87e92b0a4a65edbaee339361f662c589ad1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b1e5b95cd807d28a81a8380cc1c05823e211daa8a0bada47215d3275f2b0385"
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

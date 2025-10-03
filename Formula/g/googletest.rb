class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://google.github.io/googletest/"
  url "https://github.com/google/googletest/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "65fab701d9829d38cb77c14acdc431d2108bfdbf8979e40eb8ae567edf10b27c"
  license "BSD-3-Clause"
  head "https://github.com/google/googletest.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a37e854f5861f02de03ad664562e70ba2b1bc87d4ea189ae67fff654124ee0b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1aae318584d44e0b917d091fe609a9fc6f0036b3afcb7334708ae9d2a9b84de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "251748848e8ba7dbc7c79401ddaea335303d24c17044b5e94eee08db0977fe93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcdfeca18aa3608ea45f6a2e41f0cb009441a61716a7598730de4da7a7cd5563"
    sha256 cellar: :any_skip_relocation, sonoma:        "34d2c867c3210fc18dbe7929b51180d994f52353d3cb0a9127faa418ccc27b22"
    sha256 cellar: :any_skip_relocation, ventura:       "07d838f55cea57ab4f8cdc160818ed3d0cfa3b5a44f3a7753dba4615d2d8f218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e9d2bbc937219b6d7ce0e9c9be6c70e4a8c667eff5f02e6900200562d78bed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71854dc8c3b2a13a96c490fa30b2076673023370d445cba2820095be3ef95ed4"
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

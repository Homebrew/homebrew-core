class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://google.github.io/googletest/"
  url "https://github.com/google/googletest/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "65fab701d9829d38cb77c14acdc431d2108bfdbf8979e40eb8ae567edf10b27c"
  license "BSD-3-Clause"
  head "https://github.com/google/googletest.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec7368aaeb0d09dcab75a230f7b5a7db6f85dd1270fa7425c3cbb92fea187375"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e657620864762a65a2a2417e0f15bf6f32c6c7a1ed01e48e108e5f972a74d77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e0935d01dd27b107fbc52b2932007d5379abef84cba41e1ff9b4c7dd5ae896b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e262a6fed7e35a951a30f61363f802d2a95533a038989c23caa25c1c62cc265b"
    sha256 cellar: :any_skip_relocation, ventura:       "98b453d726dfc77def1c06896ff974c00b3a6ad26c943204bf8c10de66c9751d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b3a3bf959e4676e3193ae6a2f94b1fad5105cb9af1302f8556c749fed76d638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3209555def5bd0c5ffaf61cd972fa0c13963932460fcbb7772b85fb92dd5e09"
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

class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/v1.13.0.tar.gz"
  sha256 "ad7fdba11ea011c1d925b3289cf4af2c66a352e18d4c7264392fead75e919363"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78afe4f6baa4bd3bb904aa4113210e106c70281c10d7d809972b137e0f3b733d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d0360de5b6aa737b19633fad06f8a2a7463211681c530056c58b620262bd093"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bea1b0a8521f01edb4ff182f41438817132cff152956b45b724a40bad323972"
    sha256 cellar: :any_skip_relocation, ventura:        "c94b1fd4180b91725513c61019b8f69d751ca935c7720e3e3d1894570f205c90"
    sha256 cellar: :any_skip_relocation, monterey:       "c5102924eb2ae444391a464993750439bb266ba1ef1e7ee5265a2c706bfa0650"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f7e93be6200609ff7150378e78135588f6266db247b50b301b432e7af21c5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da0c509c2d6a62843c4284b455d00a674162ace65661dd40dfad6f92fb55f48"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # for use case like `#include "googletest/googletest/src/gtest-all.cc"`
    (include/"googlemock/googlemock/src").install Dir["googlemock/src/*"]
    (include/"googletest/googletest/src").install Dir["googletest/src/*"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtest/gtest.h>
      #include <gtest/gtest-death-test.h>

      TEST(Simple, Boolean)
      {
        ASSERT_TRUE(true);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lgtest", "-lgtest_main", "-pthread", "-o", "test"
    system "./test"
  end
end

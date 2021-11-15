class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/release-1.11.0.tar.gz"
  sha256 "b4870bf121ff7795ba20d20bcdd8627b8e088f2d1dab299a031c1034eddc93d5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5643998289368581eb4c81fd36e4cc3311ab92782db116d1f46c659d609523f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53a1b277842358ceae62800c9af78271a0a33043eff7f007110353941ace54d6"
    sha256 cellar: :any_skip_relocation, monterey:       "65d52d92904a3167ae1dc2a420dd56da5c81f3c4bd394f45ab4b8fd6b620a209"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ff36ee689017d9f973acbc0407eaf8135d983028e85d1e6375a6a144c829e7e"
    sha256 cellar: :any_skip_relocation, catalina:       "38290ffd89c69da85af50bb3e1c1e670440b59a342865a64ce50b7abb1e424aa"
    sha256 cellar: :any_skip_relocation, mojave:         "0581f86b3dd88e39339b4cf3b6b0174109491e2d4aa97cd49369381c6611cff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "929f3a916ff562ab210129b6e45c06f10dbdecbce115f2b55e482cda29ae50bf"
  end

  depends_on "cmake" => :build

  conflicts_with "nss", because: "both install `libgtest.a`"

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
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lgtest", "-lgtest_main", "-pthread", "-o", "test"
    system "./test"
  end
end

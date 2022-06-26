class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/release-1.12.0.tar.gz"
  sha256 "2a4f11dce6188b256f3650061525d0fe352069e5c162452818efbbf8d0b5fe1c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86cd21c7b3fac1acba48a1f28e1bead799640a05c61ed7944891fcc411b8ce2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cca9b050ae45a9617d92cafd864d91379ec59bda05b9f353f130bd9ef8bf910e"
    sha256 cellar: :any_skip_relocation, monterey:       "8452430bfa0f8a5f20737cc455f29c66a1e102b360a9bdeca58bedc6c20490a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "23b3f9e12eb1fe8bbd6b2decb6f93a301da99fdb24e316cda06c340730ab207f"
    sha256 cellar: :any_skip_relocation, catalina:       "583fc21ec573afa92fdbdcbcf50012ab1e617ef5d53ea46ddb39e5df9d9dc136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ac1cfe862797ec4a0b447f02119c748b7849fb57caf98d6cbe76be940444755"
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
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lgtest", "-lgtest_main", "-pthread", "-o", "test"
    system "./test"
  end
end

class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/release-1.12.1.tar.gz"
  sha256 "81964fe578e9bd7c94dfdb09c8e4d6e6759e19967e397dbea48d1c10e45d0df2"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "136df6bbe33562625a64654a7a5e398b13a02f6bd1cf004fb1ab461848ba702b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8d15f600c78e4189affaf098ac674308eb67c9dca60e2f64f2b8eefd4b82d05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e72dd7898776d58f31b6ed5b487d95a08e38b75a1bff696d5e622724633c880"
    sha256 cellar: :any_skip_relocation, ventura:        "c14f1ee7c5507536a9753ffa47420c31e838c406e502a4fb2907b08994f7eee1"
    sha256 cellar: :any_skip_relocation, monterey:       "59e79a6ad6278dd1a0ffba9f65067ff8e2095d4599da64c632de2f4b5f3db00e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e35fd9bd800c8ffe070c021c374ef889ec8f26788a7b6ae70dc22b32558b0ca1"
    sha256 cellar: :any_skip_relocation, catalina:       "786560832242b13dec1b0427c68da775b986c7ec758b487bc9159c82ddddbea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68187908a5ff0161c709fbaff14c665c4f176b3bfcdaf7878da8740c824aa99d"
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

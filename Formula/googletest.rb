class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/release-1.12.1.tar.gz"
  sha256 "81964fe578e9bd7c94dfdb09c8e4d6e6759e19967e397dbea48d1c10e45d0df2"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c75a394780e2dbc934c42e0d35beeff272000cf0ef6773e7a84683b8630f39b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee80ba6764c5fb3e6e981ea9e2c2a9b9724f3c24ef854848dc7a9e335017b194"
    sha256 cellar: :any_skip_relocation, monterey:       "1341457013ac427bd7dcc1ac453c069dd5a056cf7105374f96f9cd0ff08955ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "83141b7b3b0a40183fb989362ed5d5b2d8f450075e9693496b69b6d26871e7f8"
    sha256 cellar: :any_skip_relocation, catalina:       "86d3dd9b4ee70fedb9b91a46c8807cdcd45b1cc3a2ee12eab26f2f07b2425030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db955b5cef20c15e3084d8f97dc066985c47db8555d5c97a78c69ec3770f4916"
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

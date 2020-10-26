class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
  sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebe4172d84fd8d29282e61c810e1f99b3b6b78ac0369381b617755cd070371c6" => :catalina
    sha256 "7eface4df1365cd951d402e244a28984a2f656afb2e3fee31cf046f1a8aefaff" => :mojave
    sha256 "595a13da3151557305ddf8fc479fcab3cd6041c2ee9832fe18a9f717046116b1" => :high_sierra
  end

  depends_on "cmake" => :build

  conflicts_with "nss", because: "both install `libgtest.a`"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lgtest", "-lgtest_main", "-o", "test"
    system "./test"
  end
end

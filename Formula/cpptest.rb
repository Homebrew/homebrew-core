class Cpptest < Formula
  desc "Unit testing framework handling automated tests in C++"
  homepage "https://cpptest.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cpptest/cpptest/cpptest-2.0.0/cpptest-2.0.0.tar.bz2"
  mirror "https://github.com/cpptest/cpptest/releases/download/2.0.0/cpptest-2.0.0.tar.bz2"
  sha256 "7c258936a407bcd1635a9b7719fbdcd6c6e044b5d32f53bbf6fbf6f205e5e429"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c19519f153ca1eb3480428285c87c41f4f6e9216815ce028e8f4edb6ae2ca05c"
    sha256 cellar: :any,                 arm64_big_sur:  "b76d3ce8ecaa806713abfbb903789702daa297cff3e491e670f531725c5e90b4"
    sha256 cellar: :any,                 monterey:       "3607c24f58bd5195dd7258797f9a74c48d74fa724ac4dcf9aa60610cee085966"
    sha256 cellar: :any,                 big_sur:        "89c6ffcf939917d09725840bb55497a8477ddf951895a8f62377a8ff11e11b6b"
    sha256 cellar: :any,                 catalina:       "531646bba9e8aedff87216058a90e2fdc245b11ef55ad3f5c3aaaf717fd998cb"
    sha256 cellar: :any,                 mojave:         "5a109d0b6cb796d0de9e6b32a6373e1e78fd4da316be33a26ba9c84fbf799eb8"
    sha256 cellar: :any,                 high_sierra:    "cac49d059592f8d9f030855041727a61c7358404e16fc63d106ade58253ba0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebb0d38cb3fb4038067867b4b10ff93cdc330528dc0f163d4af0a87a427a7375"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <assert.h>
      #include <cpptest.h>

      class TestCase: public Test::Suite
      {
      public:
        TestCase() { TEST_ADD(TestCase::test); }
        void test() { TEST_ASSERT(1 + 1 == 2); }
      };

      int main()
      {
        TestCase ts;
        Test::TextOutput output(Test::TextOutput::Verbose);
        assert(ts.run(output));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lcpptest", "-o", "test"
    system "./test"
  end
end

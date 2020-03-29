class Cpptest < Formula
  desc "Unit testing framework handling automated tests in C++"
  homepage "https://cpptest.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cpptest/cpptest/cpptest-2.0.0/cpptest-2.0.0.tar.bz2"
  sha256 "7c258936a407bcd1635a9b7719fbdcd6c6e044b5d32f53bbf6fbf6f205e5e429"

  bottle do
    cellar :any
    sha256 "531646bba9e8aedff87216058a90e2fdc245b11ef55ad3f5c3aaaf717fd998cb" => :catalina
    sha256 "5a109d0b6cb796d0de9e6b32a6373e1e78fd4da316be33a26ba9c84fbf799eb8" => :mojave
    sha256 "cac49d059592f8d9f030855041727a61c7358404e16fc63d106ade58253ba0f1" => :high_sierra
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
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcpptest", "-o", "test"
    system "./test"
  end
end

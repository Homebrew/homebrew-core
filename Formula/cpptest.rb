class Cpptest < Formula
  desc "Unit testing framework handling automated tests in C++"
  homepage "https://cpptest.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cpptest/cpptest/cpptest-2.0.0/cpptest-2.0.0.tar.bz2"
  sha256 "7c258936a407bcd1635a9b7719fbdcd6c6e044b5d32f53bbf6fbf6f205e5e429"

  bottle do
    cellar :any
    rebuild 1
    sha256 "539bd0186d98d9c8ecc658e0d60b1a748ef5d2f9cd18226204a634f3b141c12a" => :catalina
    sha256 "9d91d78a8a3081d6ed690810ecb4bcf3bf3010874ba859e30c0c948f7ba30db9" => :mojave
    sha256 "bd7d2b0055d1de9cce94d3695aa7c160fbe3d0780e9650c73a7543bd5726162a" => :high_sierra
    sha256 "f243764e911fe4c056f782ebee8cd84316214d961b14322b4cedc92f60478d49" => :sierra
    sha256 "216442c844ddb2886e6877cd129fda3c589dadf8ac07572e6aa05c1c3cff4669" => :el_capitan
    sha256 "e6b364e203c882063362e4a0ef6e6482420ab57b1ec24699b6da31b50f792f14" => :yosemite
    sha256 "c1f68d40bd58366d28846395169868d86a012b8d65473aa8845401619052d568" => :mavericks
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

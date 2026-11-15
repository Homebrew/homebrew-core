class Cpptest < Formula
  desc "Unit testing framework handling automated tests in C++"
  homepage "https://cpptest.sourceforge.io/"
  url "https://github.com/cpptest/cpptest/releases/download/2.0.1/cpptest-2.0.1.tar.bz2"
  sha256 "d2f13834dd9a5c4e56fa237e01d154474044687e7cc03f6c11017c5fe6ef0641"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a6e005ad6ccd746830ec51260227eb4deb051368be0e6ace27cd3e208259181b"
    sha256 cellar: :any, arm64_tahoe:       "ff05d900261e941e09c50275a3562648b96203434cdfaae13c4998c3c947a97a"
    sha256 cellar: :any, arm64_sequoia:     "78d8c7f0a5ae8a12dc07e4297cb4dfc3ecac2fc34d9abd61344b09c0ffa52c10"
    sha256 cellar: :any, arm64_linux:       "0c4a8b5d2bc3f7328882c1c0a7ff8e843e9956b12a264523df01c0a766eb7fb6"
    sha256 cellar: :any, x86_64_linux:      "763b8ebff167fb12404c1e59bfbde9827b06b4b1648f2995590ccedbac59ddfc"
  end

  head do
    url "https://github.com/cpptest/cpptest.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  deprecate! date: "2026-09-28", because: :repo_archived
  disable! date: "2027-09-28", because: :repo_archived

  deny_network_access!

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lcpptest", "-o", "test"
    system "./test"
  end
end

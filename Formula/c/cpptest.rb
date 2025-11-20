class Cpptest < Formula
  desc "Unit testing framework handling automated tests in C++"
  homepage "https://cpptest.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cpptest/cpptest/cpptest-2.0.0/cpptest-2.0.0.tar.bz2"
  mirror "https://github.com/cpptest/cpptest/releases/download/2.0.0/cpptest-2.0.0.tar.bz2"
  sha256 "7c258936a407bcd1635a9b7719fbdcd6c6e044b5d32f53bbf6fbf6f205e5e429"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b7ba7a08b1659d230bf822ed02e72535423504b3b5fe659cac6b16f6aa64d3bd"
    sha256 cellar: :any,                 arm64_sequoia:  "2e9bd9882a2be0879ed9c30b86dda312e9fdaf6f0913d1e52960e0c057454857"
    sha256 cellar: :any,                 arm64_sonoma:   "02e96560cb00bb0e4a31cbeb0e1af8fe4d24071dc8693551a444a8ca899f64de"
    sha256 cellar: :any,                 arm64_ventura:  "cc624fd1da48ba38d19025509d327580fc4d8b2603deaa398e1bdecbad88d676"
    sha256 cellar: :any,                 arm64_monterey: "c19519f153ca1eb3480428285c87c41f4f6e9216815ce028e8f4edb6ae2ca05c"
    sha256 cellar: :any,                 arm64_big_sur:  "b76d3ce8ecaa806713abfbb903789702daa297cff3e491e670f531725c5e90b4"
    sha256 cellar: :any,                 sonoma:         "da7e6e96d0971b33f75b13306310d9b73b20e353c359c65e0f8acb4af6a7b443"
    sha256 cellar: :any,                 ventura:        "64ecd7007cbc36505613a0a664d0bdac0328ff7d59767fb73abe78a2ea3db85d"
    sha256 cellar: :any,                 monterey:       "3607c24f58bd5195dd7258797f9a74c48d74fa724ac4dcf9aa60610cee085966"
    sha256 cellar: :any,                 big_sur:        "89c6ffcf939917d09725840bb55497a8477ddf951895a8f62377a8ff11e11b6b"
    sha256 cellar: :any,                 catalina:       "531646bba9e8aedff87216058a90e2fdc245b11ef55ad3f5c3aaaf717fd998cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f3e97b7775d83ef913b5d0e0c7ba785f2d12b16de00747f7aa5a6734a032ff1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebb0d38cb3fb4038067867b4b10ff93cdc330528dc0f163d4af0a87a427a7375"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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

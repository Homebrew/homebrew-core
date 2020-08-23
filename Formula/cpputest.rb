class Cpputest < Formula
  desc "C /C++ based unit xUnit test framework"
  homepage "https://www.cpputest.org/"
  url "https://github.com/cpputest/cpputest/releases/download/v4.0/cpputest-4.0.tar.gz"
  sha256 "21c692105db15299b5529af81a11a7ad80397f92c122bd7bf1e4a4b0e85654f7"
  license "BSD-3-Clause"
  head "https://github.com/cpputest/cpputest.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9e06d26ed7a552c818c7f1d6bb68ef16e7185238a14bdf0ae337a410ecb46384" => :catalina
    sha256 "59881c464ae17f1a2381145f78f614d174c83fbe8f4900e362e9a6830fcf446e" => :mojave
    sha256 "9cea67d4098efe30dd499d1a999467800ff91a9e7954ec6407b03d181a20761d" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "CppUTest/CommandLineTestRunner.h"

      TEST_GROUP(HomebrewTest)
      {
      };

      TEST(HomebrewTest, passing)
      {
        CHECK(true);
      }
      int main(int ac, char** av)
      {
        return CommandLineTestRunner::RunAllTests(ac, av);
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lCppUTest", "-o", "test"
    assert_match /OK \(1 tests/, shell_output("./test")
  end
end

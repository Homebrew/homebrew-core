class Cpputest < Formula
  desc "C /C++ based unit xUnit test framework"
  homepage "https://www.cpputest.org/"
  url "https://github.com/cpputest/cpputest/releases/download/v4.0/cpputest-4.0.tar.gz"
  sha256 "21c692105db15299b5529af81a11a7ad80397f92c122bd7bf1e4a4b0e85654f7"
  head "https://github.com/cpputest/cpputest.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f5a93b357ee53253a4611aeb9bc8291c8b0ddaac784a9ccd566f04d97dcba5a" => :catalina
    sha256 "7039bee956ef7c571cea010678eceb5a2804e782438b9dd5c08e05ea17440a98" => :mojave
    sha256 "3ad1b1d195d4e276877831e4030817de35c1e92c878f035c47124c49118968b9" => :high_sierra
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

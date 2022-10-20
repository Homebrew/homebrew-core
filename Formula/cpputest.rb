class Cpputest < Formula
  desc "C /C++ based unit xUnit test framework"
  homepage "https://www.cpputest.org/"
  url "https://github.com/cpputest/cpputest/releases/download/v4.0/cpputest-4.0.tar.gz"
  sha256 "21c692105db15299b5529af81a11a7ad80397f92c122bd7bf1e4a4b0e85654f7"
  license "BSD-3-Clause"
  head "https://github.com/cpputest/cpputest.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12658e53f9987e135b9e375e9f143a9a2a259591057cb230ebe8fc2a8edd138b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51cc4f2febbce066e2c57af7a50c816cbb02ec5c61394657e9fb4fef5977e8d0"
    sha256 cellar: :any_skip_relocation, monterey:       "2ebba02ed9e1c87a6805e2c402433e59c9c9a0e377e179dc65e3d7c9f56dbbea"
    sha256 cellar: :any_skip_relocation, big_sur:        "37ccb80c5598e80ecacd6b5b33a610ce38666e9878cb7365a0f79e5705df49a0"
    sha256 cellar: :any_skip_relocation, catalina:       "9e06d26ed7a552c818c7f1d6bb68ef16e7185238a14bdf0ae337a410ecb46384"
    sha256 cellar: :any_skip_relocation, mojave:         "59881c464ae17f1a2381145f78f614d174c83fbe8f4900e362e9a6830fcf446e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9cea67d4098efe30dd499d1a999467800ff91a9e7954ec6407b03d181a20761d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4fb771aa9c96a9d5fa6f88f1172d94ed171b1b2ce87a353828771b48d732c68"
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
    assert_match "OK (1 tests", shell_output("./test")
  end
end

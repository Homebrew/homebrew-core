class Cpputest < Formula
  desc "C /C++ based unit xUnit test framework"
  homepage "https://cpputest.github.io/"
  url "https://github.com/cpputest/cpputest/releases/download/v4.0/cpputest-4.0.tar.gz"
  sha256 "21c692105db15299b5529af81a11a7ad80397f92c122bd7bf1e4a4b0e85654f7"
  license "BSD-3-Clause"
  head "https://github.com/cpputest/cpputest.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "abff3233390673fd95af1c7bccd0b1b9c9687db0057b816cdb43b996f1d0bf73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "04a3efc8b2286e305c60c9bb9f71d34f8fbfee43d875192e0a97546c92e67658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1854435e03a5f52bbf7fec9ce30d2502c2b00ecf037428d2aa44b3ee3018985"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7482a5b8049dbd3dd105d73392d98cdc45596f2411069245d4ecc4e75f75e857"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12658e53f9987e135b9e375e9f143a9a2a259591057cb230ebe8fc2a8edd138b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51cc4f2febbce066e2c57af7a50c816cbb02ec5c61394657e9fb4fef5977e8d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c287a3cab4f7364184c2ec63cf45c249eb8d3faf6a4b21c529cdc20ace922ec1"
    sha256 cellar: :any_skip_relocation, ventura:        "ee957c107b4c8972e0acdf8b23db196e710a3eddbc9efe76bb14f9cf1f0e5e8d"
    sha256 cellar: :any_skip_relocation, monterey:       "2ebba02ed9e1c87a6805e2c402433e59c9c9a0e377e179dc65e3d7c9f56dbbea"
    sha256 cellar: :any_skip_relocation, big_sur:        "37ccb80c5598e80ecacd6b5b33a610ce38666e9878cb7365a0f79e5705df49a0"
    sha256 cellar: :any_skip_relocation, catalina:       "9e06d26ed7a552c818c7f1d6bb68ef16e7185238a14bdf0ae337a410ecb46384"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d93627b9eacfae5a05edbc1a678dfb89652ca842905d10993b35861913fde598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4fb771aa9c96a9d5fa6f88f1172d94ed171b1b2ce87a353828771b48d732c68"
  end

  depends_on "cmake" => :build

  def install
    # Backport support for CMake 4. Remove in the next release
    # https://github.com/cpputest/cpputest/commit/fbb8526750aa370e642da7c21a98d6efdf7a3f37
    inreplace "CMakeLists.txt", /(cmake_minimum_required\(VERSION) 3\.1\)/, "\\1 3.8)" if build.stable?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lCppUTest", "-o", "test"
    assert_match "OK (1 tests", shell_output("./test")
  end
end

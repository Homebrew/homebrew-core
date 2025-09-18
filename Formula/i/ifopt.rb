class Ifopt < Formula
  desc "Light-weight C++ Interface to Nonlinear Programming Solvers"
  homepage "https://wiki.ros.org/ifopt"
  url "https://github.com/ethz-adrl/ifopt/archive/refs/tags/2.1.4.tar.gz"
  sha256 "da38f91a282f3ed305db163954c37d999b6e95f5d2c913a63bae3fef9ffb3a37"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5bf0d19327f812c4fafdd5bf01874b2d4a3699dc194d9e1d57cfe7936b8b6020"
    sha256 cellar: :any,                 arm64_sequoia: "7f3e04dba4e270d64095bf3835bde2cf2fcb709e86cfbdad8d156859ff14238f"
    sha256 cellar: :any,                 arm64_sonoma:  "e43d5ec40d0a0c692f6ab0271f10df4e5ab6a3dd0cbdb83209c274cf5d816324"
    sha256 cellar: :any,                 arm64_ventura: "f545c8e42c49be06e5c7f2cf820d20850199be87eea52016a63aef2ae350ca66"
    sha256 cellar: :any,                 sonoma:        "4c05cd8ad919c075bdd3eeb378b5cf0094e95a1157ed89c6645887c4a3fd2290"
    sha256 cellar: :any,                 ventura:       "c1e79916555fefb52c6175c441b0a26f402dc6b8895313ea5ae7963c66434e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "832619dd1e2b379e80f7ec2447aaf912310f8ba8dd46b835c3afe892ee91a03c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab1eef461f9e9d7b924d607a0831ac311656735942aeb701a09b6bd504123b6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"
  depends_on "ipopt"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ifopt_ipopt/test"
  end

  test do
    cp pkgshare/"test/ex_test_ipopt.cc", "test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{Formula["eigen"].opt_include}/eigen3",
                    "-L#{lib}", "-lifopt_core", "-lifopt_ipopt"
    assert_match "Optimal Solution Found", shell_output("./test")
  end
end

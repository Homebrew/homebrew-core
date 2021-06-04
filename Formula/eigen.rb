class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://gitlab.com/libeigen/eigen/-/archive/3.3.9/eigen-3.3.9.tar.gz"
  sha256 "7985975b787340124786f092b3a07d594b2e9cd53bbfe5f3d9b1daee7d55f56f"
  license "MPL-2.0"
  head "https://gitlab.com/libeigen/eigen.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e03d900e18903478875f1c354ee169373be0fdc49996da784e4a55f7b3c3594a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3305d00c64e0bd6f53e45858b92be3d72827c02b2e2f71d4edd01f1efaa1080"
    sha256 cellar: :any_skip_relocation, catalina:      "172a99d2e904ece3409ae56304beb77ff638313e52b7f1eb00ce58d8a11a3a68"
    sha256 cellar: :any_skip_relocation, mojave:        "dada92aa488d06af18fbf589a46c490a5b9090ae75d0027d5dae109ddad792e5"
  end

  depends_on "cmake" => :build

  conflicts_with "freeling", because: "freeling ships its own copy of eigen"

  def install
    mkdir "eigen-build" do
      args = std_cmake_args
      args << "-Dpkg_config_libdir=#{lib}" << ".."
      system "cmake", *args
      system "make", "install"
    end
    (share/"cmake/Modules").install "cmake/FindEigen3.cmake"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <Eigen/Dense>
      using Eigen::MatrixXd;
      int main()
      {
        MatrixXd m(2,2);
        m(0,0) = 3;
        m(1,0) = 2.5;
        m(0,1) = -1;
        m(1,1) = m(1,0) + m(0,1);
        std::cout << m << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/eigen3", "-o", "test"
    assert_equal %w[3 -1 2.5 1.5], shell_output("./test").split
  end
end

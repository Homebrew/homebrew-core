class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://gitlab.com/libeigen/eigen/-/archive/3.3.9/eigen-3.3.9.tar.gz"
  sha256 "7985975b787340124786f092b3a07d594b2e9cd53bbfe5f3d9b1daee7d55f56f"
  license "MPL-2.0"
  head "https://gitlab.com/libeigen/eigen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dca6a43943d74019c173745502a2cd0ec2fde1539d0a59011ada224e601eb974" => :big_sur
    sha256 "2903f6439e0f52e371f6d0a3a8f167a35ce4c07662b04a2e86b26243f19d24ba" => :catalina
    sha256 "39ab24e3cd9d515b34f220eae5489e4effa732871d36c8e11daa588265ed89d3" => :mojave
    sha256 "3288da7047cf65b70c315806e97443743273d27fbcfeace9c1061ecbc2faeb4c" => :high_sierra
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

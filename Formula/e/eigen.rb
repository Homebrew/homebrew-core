class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz"
  sha256 "8586084f71f9bde545ee7fa6d00288b264a2b7ac3607b974e54d13e7162c1c72"
  license "MPL-2.0"
  revision 1
  head "https://gitlab.com/libeigen/eigen.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "b7d3fc4023e664e69392994530a88aa0b6f2a81067da6d64727cf983db2c1bd1"
  end

  depends_on "cmake" => :build

  conflicts_with "freeling", because: "freeling ships its own copy of eigen"

  def install
    system "cmake", "-S", ".", "-B", "eigen-build", "-Dpkg_config_libdir=#{lib}", *std_cmake_args
    system "cmake", "--install", "eigen-build"
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

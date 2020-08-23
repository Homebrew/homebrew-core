class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.tar.bz2"
  sha256 "685adf14bd8e9c015b78097c1dc22f2f01343756f196acdc76a678e1ae352e11"
  license "MPL-2.0"
  head "https://gitlab.com/libeigen/eigen"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7770e95151199c72350c1f3990bfa153026fbe2f8e73ffc1d0cdbaf9774215e8" => :catalina
    sha256 "7770e95151199c72350c1f3990bfa153026fbe2f8e73ffc1d0cdbaf9774215e8" => :mojave
    sha256 "7770e95151199c72350c1f3990bfa153026fbe2f8e73ffc1d0cdbaf9774215e8" => :high_sierra
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

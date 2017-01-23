class EigenAT32 < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://bitbucket.org/eigen/eigen/get/3.2.10.tar.bz2"
  sha256 "760e6656426fde71cc48586c971390816f456d30f0b5d7d4ad5274d8d2cb0a6d"

  keg_only "Older version of eigen"

  depends_on "cmake" => :build

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
    (testpath/"test.cpp").write <<-EOS.undent
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

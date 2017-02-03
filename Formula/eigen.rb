class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://bitbucket.org/eigen/eigen/get/3.3.2.tar.bz2"
  sha256 "3e1fa6e8c45635938193f84fee6c35a87fac26ee7c39c68c230e5080c4a8fe98"
  head "https://bitbucket.org/eigen/eigen", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "e0a5c96d5bbe5f9dcd7ffc4e75d2c83dd92d40f953623a96dc3705799b9a3ce3" => :sierra
    sha256 "9ef7e849e5496407789e2113a25097b1a797086eba6d8350a020a3905fcb0f1a" => :el_capitan
    sha256 "9ef7e849e5496407789e2113a25097b1a797086eba6d8350a020a3905fcb0f1a" => :yosemite
  end

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

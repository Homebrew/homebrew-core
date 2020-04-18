class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.tar.bz2"
  sha256 "685adf14bd8e9c015b78097c1dc22f2f01343756f196acdc76a678e1ae352e11"
  head "https://gitlab.com/libeigen/eigen"

  bottle do
    cellar :any_skip_relocation
    sha256 "a756d567dc590cdad796aa2d442d08bbdb973fdb70cd657b530224e4d24c6b68" => :catalina
    sha256 "683c2dd898245f61c298d1f2675885e7c67ec7e18f6665df1ec56f088bd670f4" => :mojave
    sha256 "79c52d57394cf485eb324effab69279e4f3beb63cbacfa600ae0a678d852a827" => :high_sierra
    sha256 "79c52d57394cf485eb324effab69279e4f3beb63cbacfa600ae0a678d852a827" => :sierra
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

class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://bitbucket.org/eigen/eigen/get/3.3.5.tar.bz2"
  sha256 "7352bff3ea299e4c7d7fbe31c504f8eb9149d7e685dec5a12fbaa26379f603e2"
  head "https://bitbucket.org/eigen/eigen", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "4cc2b76353629941ff0098928d331e1620c5e27e5d55f337deae8b35f8af1b97" => :high_sierra
    sha256 "73b77dbad9910ff34a3b3dfe24db8c9e84b0bf0dc6e2ea8ebd9cb663083fa9e1" => :sierra
    sha256 "8bd6a07c4625266bd8631f636b317b19916611308e7f9eeec5f5b8b847327ef9" => :el_capitan
    sha256 "8bd6a07c4625266bd8631f636b317b19916611308e7f9eeec5f5b8b847327ef9" => :yosemite
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

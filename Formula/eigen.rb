class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://gitlab.com/libeigen/eigen/-/archive/3.3.8/eigen-3.3.8.tar.gz"
  sha256 "146a480b8ed1fb6ac7cd33fec9eb5e8f8f62c3683b3f850094d9d5c35a92419a"
  license "MPL-2.0"
  revision 1
  head "https://gitlab.com/libeigen/eigen"

  bottle do
    cellar :any_skip_relocation
    sha256 "2903f6439e0f52e371f6d0a3a8f167a35ce4c07662b04a2e86b26243f19d24ba" => :catalina
    sha256 "39ab24e3cd9d515b34f220eae5489e4effa732871d36c8e11daa588265ed89d3" => :mojave
    sha256 "3288da7047cf65b70c315806e97443743273d27fbcfeace9c1061ecbc2faeb4c" => :high_sierra
  end

  depends_on "cmake" => :build

  conflicts_with "freeling", because: "freeling ships its own copy of eigen"

  # Emergency fix for build failures with OpenMP. Remove with the next release.
  patch do
    url "https://gitlab.com/libeigen/eigen/-/commit/ef3cc72cb65e2d500459c178c63e349bacfa834f.patch?full_index=1"
    sha256 "c04d624d550b119be0f810786baba7e0d7809edefd4854a2db6dbd98a7da5a7d"
  end

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

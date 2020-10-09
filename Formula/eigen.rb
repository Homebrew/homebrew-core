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
    sha256 "21834e0e508d5b7e1dc691652b12c72c6157f5dd59772cf1afcbc4de3387d6c1" => :catalina
    sha256 "9331571eab7031ac0a10403065956348251c074f37cda47fafe94fd3187f0cfa" => :mojave
    sha256 "af8fbdf33dcfa2ad62b932008359ef49ecf2a57feb7bd1aaa831d57f76ed8c96" => :high_sierra
  end

  depends_on "cmake" => :build

  conflicts_with "freeling", because: "freeling ships its own copy of eigen"

  # Emergency fix for build failures with OpenMP. Remove with the next release.
  patch do
    url "https://gitlab.com/libeigen/eigen/-/commit/ef3cc72cb65e2d500459c178c63e349bacfa834f.diff"
    sha256 "b8877a84c4338f08ab8a6bb8b274c768e93d36ac05b733b078745198919a74bf"
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

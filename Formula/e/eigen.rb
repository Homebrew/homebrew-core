class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://gitlab.com/libeigen/eigen"
  url "https://gitlab.com/libeigen/eigen/-/archive/5.0.0/eigen-5.0.0.tar.gz"
  sha256 "315c881e19e17542a7d428c5aa37d113c89b9500d350c433797b730cd449c056"
  license all_of: [
    "MPL-2.0",
    "Apache-2.0",   # BFloat16.h
    "BSD-3-Clause", # bindings to BLAS, LAPACKe and MKL
    "Minpack",      # LevenbergMarquardt
  ]
  head "https://gitlab.com/libeigen/eigen.git", branch: "master"

  livecheck do
    url "https://gitlab.com/api/v4/projects/libeigen%2Feigen/releases"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json.filter_map { |item| item["tag_name"]&.[](regex, 1) unless item["upcoming_release"] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "64ee1c43cc38e7ceb2efcfacd905212dcb4ffb1434d3833c006cbffdd3a7608c"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DEIGEN_BUILD_BLAS=OFF
      -DEIGEN_BUILD_LAPACK=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}/eigen3", "-o", "test"
    assert_equal %w[3 -1 2.5 1.5], shell_output("./test").split
  end
end

class EigenAT3 < Formula
  desc "C++ template library for linear algebra"
  homepage "https://gitlab.com/libeigen/eigen"
  url "https://gitlab.com/libeigen/eigen/-/archive/3.4.1/eigen-3.4.1.tar.gz"
  sha256 "b93c667d1b69265cdb4d9f30ec21f8facbbe8b307cf34c0b9942834c6d4fdbe2"
  license all_of: [
    "MPL-2.0",
    "Apache-2.0",    # BFloat16.h
    "BSD-3-Clause",  # bindings to BLAS, LAPACKe and MKL
    "Minpack",       # LevenbergMarquardt
    "LGPL-2.1-only", # IterativeSolvers
  ]

  livecheck do
    url "https://gitlab.com/api/v4/projects/libeigen%2Feigen/releases"
    regex(/^v?(3(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json.filter_map { |item| item["tag_name"]&.[](regex, 1) unless item["upcoming_release"] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "213fb8af2b98a2329bb16d3e3ed14e657af1ba01ac48c2c59613f465158196d0"
  end

  keg_only :versioned_formula

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

class Lbfgspp < Formula
  desc "Header-only C++ library for L-BFGS and L-BFGS-B algorithms"
  homepage "https://lbfgspp.statr.me/"
  url "https://github.com/yixuan/LBFGSpp/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "39c4aaebd8b94ccdc98191d51913a31cddd618cc0869d99f07a4b6da83ca6254"
  license "MIT"
  revision 1
  head "https://github.com/yixuan/LBFGSpp.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5a7448c359aea68fd3317768eb086befc6442be56cf0d1c864d59aea9150d9da"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  # Apply open PR to support eigen 5.0.0
  # PR ref: https://github.com/yixuan/LBFGSpp/pull/48
  patch do
    url "https://github.com/yixuan/LBFGSpp/commit/b7c91e57a7e5319b4f168ab5e381e92e95236694.patch?full_index=1"
    sha256 "fbd364dae7afe1ae36b344a82425e42d4702f60da7e17e6789d289c03e0bef5e"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <Eigen/Core>
      #include <iostream>
      #include <LBFGS.h>

      using Eigen::VectorXd;
      using namespace LBFGSpp;

      class Rosenbrock {
      private:
          int n;
      public:
          Rosenbrock(int n_) : n(n_) {}
          double operator()(const VectorXd& x, VectorXd& grad) {
              double fx = 0.0;
              for(int i = 0; i < n; i += 2) {
                  double t1 = 1.0 - x[i];
                  double t2 = 10 * (x[i + 1] - x[i] * x[i]);
                  grad[i + 1] = 20 * t2;
                  grad[i]     = -2.0 * (x[i] * grad[i + 1] + t1);
                  fx += t1 * t1 + t2 * t2;
              }
              return fx;
          }
      };

      int main() {
          const int n = 10;
          LBFGSParam<double> param;
          param.epsilon = 1e-6;
          param.max_iterations = 100;
          LBFGSSolver<double> solver(param);
          Rosenbrock fun(n);
          VectorXd x = VectorXd::Zero(n);
          double fx;
          solver.minimize(fun, x, fx);
          std::cout << x.transpose() << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, testpath/"test.cpp", "-std=c++14",
           "-I#{include}", "-I#{Formula["eigen"].opt_include}/eigen3",
           "-o", "test"
    assert_equal "1 1 1 1 1 1 1 1 1 1", shell_output(testpath/"test").chomp
  end
end

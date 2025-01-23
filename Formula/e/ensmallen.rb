class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/refs/tags/2.22.1.tar.gz"
  sha256 "daf53fe96783043ca33151a3851d054a826fab8d9a173e6bcbbedd4a7eabf5b1"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61d418e3413b26ef60b88fdfe2f104c6605b9619ff0e0de91778cb84f7a0bb70"
  end

  depends_on "cmake" => :build
  depends_on "armadillo"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ensmallen.hpp>
      using namespace ens;
      int main()
      {
        test::RosenbrockFunction f;
        arma::mat coordinates = f.GetInitialPoint();
        Adam optimizer(0.001, 32, 0.9, 0.999, 1e-8, 3, 1e-5, true);
        optimizer.Optimize(f, coordinates);
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{Formula["armadillo"].opt_lib}",
                    "-larmadillo", "-o", "test"
  end
end

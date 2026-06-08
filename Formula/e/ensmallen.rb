class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/refs/tags/3.11.0.tar.gz"
  sha256 "8839a6f50aada2a930e7d79e2834a64ea8e782687d1709b7a554ceb4014be533"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "56ae6b67c79ced73d05763cde6136c5def299d32d928fdf416ef9f9228542dc2"
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

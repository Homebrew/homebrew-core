class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.19.0.tar.gz"
  sha256 "f9b280e03266b308d2772ab7e1dd962adcfa98b0552b05795f8ac81ec15eb270"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/mlpack/ensmallen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7fcabf4447345e3fafad47b99f61aadd0d3ddda72c60bec28c5527a8133c44b"
  end

  depends_on "cmake" => :build
  depends_on "armadillo"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{Formula["armadillo"].opt_lib}",
                    "-larmadillo", "-o", "test"
  end
end

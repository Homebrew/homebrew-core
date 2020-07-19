class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.13.0.tar.gz"
  sha256 "04785a050498cb85e5f1352912277e9cb4dea1ad51ab0c1b513badaa9a854558"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a6e364933f46465bb40d71350d231cd1dfaa240ccfd206663cc1f33f38dc791" => :catalina
    sha256 "5a6e364933f46465bb40d71350d231cd1dfaa240ccfd206663cc1f33f38dc791" => :mojave
    sha256 "5a6e364933f46465bb40d71350d231cd1dfaa240ccfd206663cc1f33f38dc791" => :high_sierra
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
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-I#{Formula["armadillo"].opt_lib}/libarmadillo",
                    "-o", "test"
  end
end

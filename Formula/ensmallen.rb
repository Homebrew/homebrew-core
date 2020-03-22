class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.11.5.tar.gz"
  sha256 "caa714f14dec80a7b146d829c9e90732ad9b7d54aa322288aedaed6def4a9259"

  bottle do
    cellar :any_skip_relocation
    sha256 "48b4f57bf148fd75ae94b464a609bb1963b5d426a574490c5ba6829cbf1572fb" => :catalina
    sha256 "48b4f57bf148fd75ae94b464a609bb1963b5d426a574490c5ba6829cbf1572fb" => :mojave
    sha256 "48b4f57bf148fd75ae94b464a609bb1963b5d426a574490c5ba6829cbf1572fb" => :high_sierra
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

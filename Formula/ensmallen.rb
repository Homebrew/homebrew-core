class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.12.1.tar.gz"
  sha256 "9d574de6a7096282502113bd80fe8d8ebdbbf0118b01c7fe7298b92f5f47e53b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "13f0abb19e1a1fa352d5de61de0467a9460c3c4d6e0eda0681bdb38eedd2aa7c" => :catalina
    sha256 "13f0abb19e1a1fa352d5de61de0467a9460c3c4d6e0eda0681bdb38eedd2aa7c" => :mojave
    sha256 "13f0abb19e1a1fa352d5de61de0467a9460c3c4d6e0eda0681bdb38eedd2aa7c" => :high_sierra
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

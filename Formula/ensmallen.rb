class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.12.1.tar.gz"
  sha256 "9d574de6a7096282502113bd80fe8d8ebdbbf0118b01c7fe7298b92f5f47e53b"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fab2ea09493f415baac196e372ce84cd20de4c84d2fd880dc58e886b2a1b94b" => :catalina
    sha256 "4fab2ea09493f415baac196e372ce84cd20de4c84d2fd880dc58e886b2a1b94b" => :mojave
    sha256 "4fab2ea09493f415baac196e372ce84cd20de4c84d2fd880dc58e886b2a1b94b" => :high_sierra
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

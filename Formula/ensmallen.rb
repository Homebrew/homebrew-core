class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.14.1.tar.gz"
  sha256 "06129bec8500c4caaa1b0aadc03cad81c5835cc4dc99e5487e7dcebfd5c96e66"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "330d7065f4667d5a3fad9963d57c77b9865791fec2bb13f7a266ff7141d00d1d" => :catalina
    sha256 "34331fbb7b81c77b50ba23cdc2a0cc5f794461c0d55817da7de301022e945939" => :mojave
    sha256 "d1c51c707e7a316191c16f51a90e6b3f58a94fbc33f0a8d1427630aa4a58dda2" => :high_sierra
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

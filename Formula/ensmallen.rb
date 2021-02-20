class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.16.0.tar.gz"
  sha256 "3fb2181a5335daf8ba4e8aaecf345dfcc69fdd13d29b05b7c98b8403612a1109"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "69687255c911a23223a15c03908b7f2b921ee3f1946647a299de0656615ae6d8"
    sha256 cellar: :any_skip_relocation, catalina: "587b0020ea816c912ca02dd7a06d5056428c62b260dfd5110ee9ea138ecdea69"
    sha256 cellar: :any_skip_relocation, mojave:   "d2b59e020601dfacbaecc1056047240e5a400ac6f3087746c1ce6158a17b7224"
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

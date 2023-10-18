class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.20.0.tar.gz"
  sha256 "5c7cea756e544795b3861d171f7cc28ba0a0be6297f84026b0b17e1dfc583f24"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0068070cf8fd7ce0b31e1488b4ab225fe0870816f60af08e37eae3296219165e"
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

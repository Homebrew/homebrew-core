class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.16.2.tar.gz"
  sha256 "b4c9c6dcb3ec7a034f4668b0b71048f2e28c01aa57ce4291d6b3fca8c5bfeed2"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/mlpack/ensmallen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "340c4a47dc095893ce5d1047715c52a012e1b96a09b43f0e264ce93ffb401ec7"
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

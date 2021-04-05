class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.16.2.tar.gz"
  sha256 "b4c9c6dcb3ec7a034f4668b0b71048f2e28c01aa57ce4291d6b3fca8c5bfeed2"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/mlpack/ensmallen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "e1f7354fa4e31a5312961d8c47c1b45f81d590f3074a5214a6c0ccf2e9e71b8f"
    sha256 cellar: :any_skip_relocation, catalina: "bde043315aa52c771e43a628a9282de67e3599f982364da216dca51ca3db0966"
    sha256 cellar: :any_skip_relocation, mojave:   "03ff20db9a165c237b5ef647fa7fefad606d7ae2f422ec52294d64bd254a5d9d"
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

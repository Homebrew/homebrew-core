class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.18.2.tar.gz"
  sha256 "62f17232d1f8236f71de967f349ef4d7d09ffd3d80c8fb9236bbdf2b5a6ea22b"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6056a1b9ef0812407989420dc40a2a0d59d3aecc9033ab21bdb52c7ffaa14496"
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

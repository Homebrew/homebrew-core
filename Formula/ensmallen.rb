class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.18.0.tar.gz"
  sha256 "4ac91619f7652ae34043af52d4eac3c957af0653ace55ad3b936e5c9bac948b6"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3d6a01b292894bad46c035794e4de705221b0c9cafd4f329a971b975efb32d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "d3d6a01b292894bad46c035794e4de705221b0c9cafd4f329a971b975efb32d1"
    sha256 cellar: :any_skip_relocation, catalina:      "d3d6a01b292894bad46c035794e4de705221b0c9cafd4f329a971b975efb32d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3d6a01b292894bad46c035794e4de705221b0c9cafd4f329a971b975efb32d1"
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

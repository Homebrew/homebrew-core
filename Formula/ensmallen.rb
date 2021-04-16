class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.16.2.tar.gz"
  sha256 "b4c9c6dcb3ec7a034f4668b0b71048f2e28c01aa57ce4291d6b3fca8c5bfeed2"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/mlpack/ensmallen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "67c958656b94df83c91d9afb093d63b68cd0d64c78925a82c036a60646407e1d"
    sha256 cellar: :any_skip_relocation, big_sur:       "1de9180257369d90837377afc898ef254ae9a9d5e2ca96d2ba03e8a1f70e325c"
    sha256 cellar: :any_skip_relocation, catalina:      "bf27a3835fbb2600d76a3e9f7271303e09518738bbe4179349d2fce5af4e45d6"
    sha256 cellar: :any_skip_relocation, mojave:        "6efbf38dff5223316e4edc0aa28d6d660aa6aa7c2a9407f6e59bd46ac6109855"
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

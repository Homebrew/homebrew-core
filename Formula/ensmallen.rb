class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.16.1.tar.gz"
  sha256 "8afda8ed8e99889ca9ac1c0caf2563f1d649a9d412b4e8aa0698686351abcd16"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "90556505e57a1fedfee45b1fdc71fc2d04435c4f56510fc23c5d045a2a609a30"
    sha256 cellar: :any_skip_relocation, catalina: "97ece67ff32c345316d773ad7c1adffa0a33711edd0f7607945bd9104588b40c"
    sha256 cellar: :any_skip_relocation, mojave:   "17bab1b071c058a3f79af23692b403a25474d2a0f74fee9318e639d6463f7872"
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

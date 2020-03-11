class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.11.4.tar.gz"
  sha256 "9c131c244d7b407655812e113b0fda27b8dfaba8ad04397c333c982c5f069696"

  bottle do
    cellar :any_skip_relocation
    sha256 "e24b5d6fb684fe67805b4f3850cb94c0b544979754528306b50db3f1b447258d" => :catalina
    sha256 "e24b5d6fb684fe67805b4f3850cb94c0b544979754528306b50db3f1b447258d" => :mojave
    sha256 "e24b5d6fb684fe67805b4f3850cb94c0b544979754528306b50db3f1b447258d" => :high_sierra
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
    cxx_with_flags = ENV.cxx.split + ["test.cpp",
                                      "-std=c++11",
                                      "-I#{include}",
                                      "-I#{Formula["armadillo"].opt_lib}/libarmadillo",
                                      "-o", "test"]
    system *cxx_with_flags
  end
end

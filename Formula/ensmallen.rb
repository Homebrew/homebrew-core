class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.15.1.tar.gz"
  sha256 "c2123487633f6711180e3b75b78cd78e3b58735bb14bf9ba99efe5ae72e61b0e"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4dd000c255a17a2911212fa63b5b7ecc1ac83d02f69b42aa6bc6b8af2b299637" => :catalina
    sha256 "560f8768c81f9f12211c83356363495b209e2f4d890c9707c8c9a5c2f9b2cd68" => :mojave
    sha256 "5c6b5fdae1dd31ae9a976452f237bfaa31849686bcc6bb6ea9cd9ac1ba5abdb4" => :high_sierra
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

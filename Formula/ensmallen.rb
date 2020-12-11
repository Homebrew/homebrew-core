class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.15.1.tar.gz"
  sha256 "c2123487633f6711180e3b75b78cd78e3b58735bb14bf9ba99efe5ae72e61b0e"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/mlpack/ensmallen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "674c213991c16278a2b83d10f3f66a0bf2f6a9a31b762cc01c026f6061d5461d" => :big_sur
    sha256 "cf68516cb03954178975000e32770434ca57fe6ff7cd3049060edfa2963848d6" => :catalina
    sha256 "7625ecf3f624fa12c42742842d0e6e01c373acf3d7e075f96d911e834ab13d54" => :mojave
    sha256 "070c51440d22bdbdd03ea2547f72b2aab52486786dc9887af32a375710f618da" => :high_sierra
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

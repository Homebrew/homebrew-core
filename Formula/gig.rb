class Gig < Formula
  desc "Draw sample from the Generalized Inverse Gaussian distribution."
  homepage "https://github.com/Horta/gig"
  url "https://github.com/Horta/gig/archive/v0.0.3.tar.gz"
  sha256 "0289839b01536bdaeba8cef5cd61a5ff07ffd7b0776dccd60d9a4c5395fc2387"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"gig_test.cpp").write <<-EOS
    #include "gig/gig.h"

    #include <cassert>
    #include <cmath>
    #include <random>

    using std::abs;

    int main()
    {
      Random random(0);

      double lambda = 2.1;
      double chi = 0.1;
      double psi = 1.0;

      assert(abs(random.gig(lambda, chi, psi) - 1.30869321355819901) < 1e-7);

      return 0;
    }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lgig", "-o", "gig_test", "gig_test.cpp"
    system "./gig_test"
  end
end

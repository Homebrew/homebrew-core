class Openfa < Formula
  desc "Set of algorithms that implement standard models used in fundamental astronomy"
  homepage "https://gitlab.obspm.fr/imcce_openfa/openfa"
  url "https://gitlab.obspm.fr/imcce_openfa/openfa/-/archive/20231011.0.3/openfa-20231011.0.3.tar.gz"
  sha256 "e49de042025537e5cfd9ee55b28e58658efbda05e49fdc1fa90e2d347ee5d696"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e09325d56359bc60015dde514da142c8dafa405b278ad12b37d61aa9b9a50097"
    sha256 cellar: :any,                 arm64_sequoia:  "c0ba14a0c9fb154470b308670c6c8a6ea0115fe4c12aa402380cbbf0987c2252"
    sha256 cellar: :any,                 arm64_sonoma:   "385c6e6ec553fa81f6fc118cdcd561508bec55a0217605c40a7de1a6359ca8ee"
    sha256 cellar: :any,                 arm64_ventura:  "2bd63161a16bdf0b591420b4c7dcfac615fa2ed25192385923934719e2cbd2d5"
    sha256 cellar: :any,                 arm64_monterey: "d4431b5f7b7b599fd0d53231a000a57392c71a8e77b245474cde88f15931ecfd"
    sha256 cellar: :any,                 sonoma:         "bfb27bf06051d8696fc549715df202bca591628a127b317184f81cca64082cd9"
    sha256 cellar: :any,                 ventura:        "fb63e4e4c4340190d0354f95da2ddb9e7bfbc1a968a373a8946976290ddb0a5d"
    sha256 cellar: :any,                 monterey:       "90af0108825d0187e45ffa9703e803747c015d2a70617b3fc367f4342dd9f5d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "40d42069bba5856f56b9f3ac7eaeab0e0137012139bb3281d2659314d3de59bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eab4f9ca29a3d57234580cdc61c2fbe34c4493702db0517f3f3f0a6938bb6f03"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"testopenfa.c").write <<~C
      #include "openfa.h"
      #include "openfam.h"
      #include <assert.h>

      int main (void) {
        double dj1, dj2, fd;
        int iy, im, id, j;
        dj1 = 2400000.5;
        dj2 = 50123.9999;
        j = openfaJd2cal(dj1, dj2, &iy, &im, &id, &fd);
        assert (iy==1996);
        assert (im==2);
        assert (id==10);
        assert (fd<1.);
        assert (fd>0.99);
        assert (j==0);
        return 0;
      }
    C
    system ENV.cc, "testopenfa.c", "-L#{lib}", "-lopenfa", "-o", "testopenfa"
    system "./testopenfa"
  end
end

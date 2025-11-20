class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/refs/tags/3.9.1.tar.gz"
  sha256 "f6641deb07fa69165b7815de9008af3ea47eb39b2bb97521fbf74c97aba6e844"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/opencollab/arpack-ng.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49cef98cf7475c671e5826e23a50d8c093a34685d6a98ed55614916f2196408b"
    sha256 cellar: :any,                 arm64_sequoia: "476f1c28808b3115fa9cf72d17bda20b989dc60d911d3abe85be50a92bd1d6a1"
    sha256 cellar: :any,                 arm64_sonoma:  "fcc8d39b5a28e371db0331c0f2ae3de23a6c37e38e9ee5026b88e668c093ea71"
    sha256 cellar: :any,                 arm64_ventura: "99cf4eb648f19ac5355d2572ec5536624ca39d7480fd42bf00fcc478728ac9b4"
    sha256 cellar: :any,                 sonoma:        "f2b3e99ace1d79b1b69b986f2bbe88b43ccef0c2662b2158b70586b3c4a40e90"
    sha256 cellar: :any,                 ventura:       "153bbc3358e289d2ee528f481a86dcb41de9fe2947713b5e3a7241bfe45cb6de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08a91a56289af355e7139466cff2c2d882e4361bddc76d4b509bee94524154cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37cccca9e03aeb558521d7f5e3022e24c99ba52aaecddfb99fd38ce08287c5bf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "eigen"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"

  def install
    args = %W[
      --with-blas=-L#{Formula["openblas"].opt_lib}\ -lopenblas
      F77=mpif77
      --enable-mpi
      --enable-icb
      --enable-eigen
    ]

    system "./bootstrap"
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "TESTS/testA.mtx", "TESTS/dnsimp.f", "TESTS/mmio.f", "TESTS/debug.h"
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"dnsimp.f", pkgshare/"mmio.f",
                       "-L#{lib}", "-larpack",
                       "-L#{Formula["openblas"].opt_lib}", "-lopenblas"
    cp_r pkgshare/"testA.mtx", testpath
    assert_match "reached", shell_output("./test")
  end
end

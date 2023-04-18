class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.9.0.tar.gz"
  sha256 "24f2a2b259992d3c797d80f626878aa8e2ed5009d549dad57854bbcfb95e1ed0"
  license "BSD-3-Clause"
  head "https://github.com/opencollab/arpack-ng.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00a4522b3c828a4c01fd217b4f3e463e244f78176be12ef4254ea717cf777ec2"
    sha256 cellar: :any,                 arm64_monterey: "183e7b26a4013b2e985bcb9378fcfe9a26737f8453221573bd028d1195fb70e0"
    sha256 cellar: :any,                 arm64_big_sur:  "3e3d2a125a0db65151f83ce69260d269c372ff1b33de4eff237c67227f4e3897"
    sha256 cellar: :any,                 ventura:        "9f66d8634e9912fa4f307df1c9416f282cd07a24652ab5078dc5720c5cb3e87b"
    sha256 cellar: :any,                 monterey:       "f942ff4f061694774405aa2acd05f834222f2609c3609d237ca2427224154055"
    sha256 cellar: :any,                 big_sur:        "fe8f01ba84d9d5d706afa83764f795c60f6c5396e8766c3d01458c7a09d64631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38b19cff9601f7590571e03e820d65ecf1edb85875528b1f0b86991a68bfd623"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "eigen"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --with-blas=-L#{Formula["openblas"].opt_lib}\ -lopenblas
      F77=mpif77
      --enable-mpi
      --enable-icb
      --enable-icb-exmm
    ]

    system "./bootstrap"
    system "./configure", *args
    system "make"
    system "make", "install"

    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib/"pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    pkgshare.install "TESTS/testA.mtx", "TESTS/dnsimp.f",
                     "TESTS/mmio.f", "TESTS/debug.h"
  end

  test do
    ENV.fortran
    system ENV.fc, "-o", "test", pkgshare/"dnsimp.f", pkgshare/"mmio.f",
                       "-L#{lib}", "-larpack",
                       "-L#{Formula["openblas"].opt_lib}", "-lopenblas"
    cp_r pkgshare/"testA.mtx", testpath
    assert_match "reached", shell_output("./test")
  end
end

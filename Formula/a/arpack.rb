class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/refs/tags/3.9.1.tar.gz"
  sha256 "f6641deb07fa69165b7815de9008af3ea47eb39b2bb97521fbf74c97aba6e844"
  license "BSD-3-Clause"
  head "https://github.com/opencollab/arpack-ng.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "bbc370902c31da397dea1116ad0cea384c2ab8fabebfcf57a5b59dead58ed53d"
    sha256 cellar: :any,                 arm64_sonoma:  "2a38b56bc96151574fd11c85f0244f63a31f3d51305b1902b2cf2bd21c7784fa"
    sha256 cellar: :any,                 arm64_ventura: "653947ce18a5e7189e1e45a568e96670a847583cc46d979fde56f8fc295f2704"
    sha256 cellar: :any,                 sonoma:        "1694ae0fc82302280d5c96327965ca61e32bcc2c4aa75a41ba1eec6e2b0ec38f"
    sha256 cellar: :any,                 ventura:       "965eca12081b1cc6152ae3ec03c97bc9e3e90ee82c5211350e476cb90b88214e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a96492c90636b4f299ae95a9dfcf92a9b19caa8219dd6cd27bbd73c1d7d4d9f0"
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
      --enable-eigen
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
    args = (OS.mac? && MacOS.version >= :sequoia) ? ["-O2"] : []
    system ENV.fc, *args, "-o", "test", pkgshare/"dnsimp.f", pkgshare/"mmio.f",
                   "-L#{lib}", "-larpack",
                   "-L#{Formula["openblas"].opt_lib}", "-lopenblas"
    cp_r pkgshare/"testA.mtx", testpath
    assert_match "reached", shell_output("./test")
  end
end

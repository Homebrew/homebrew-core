class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.6.3.tar.gz"
  sha256 "64f3551e5a2f8497399d82af3076b6a33bf1bc95fc46bbcabe66442db366f453"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    sha256 "ddf478d1a70c309b7e623003f3bf2b88faab80a9ce28b7de4d4b52a38b074683" => :mojave
    sha256 "ef0340677c5137666d663accbcbb137496f9bb366ad1fa3b1bc70643fb43bb42" => :high_sierra
    sha256 "f6822d4de016811fb2200f576ed5257472afd57c9e13ebd6d3324d54e7ea5736" => :sierra
    sha256 "6db44ed19be3e9fc92fac97a35965156af0351b03e8f0fdba3e19529d854a0af" => :el_capitan
  end

  option "with-mpi", "Enable parallel support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gcc" # for gfortran
  depends_on "open-mpi" if build.with? "mpi"
  depends_on "veclibfort"

  def install
    args = %W[ --disable-dependency-tracking
               --prefix=#{libexec}
               --with-blas=-L#{Formula["veclibfort"].opt_lib}\ -lvecLibFort ]

    args << "F77=mpif77" << "--enable-mpi" if build.with? "mpi"

    system "./bootstrap"
    system "./configure", *args
    system "make"
    system "make", "install"

    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib/"pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    pkgshare.install "TESTS/testA.mtx", "TESTS/dnsimp.f",
                     "TESTS/mmio.f", "TESTS/debug.h"

    if build.with? "mpi"
      (libexec/"bin").install (buildpath/"PARPACK/EXAMPLES/MPI").children
    end
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"dnsimp.f", pkgshare/"mmio.f",
                       "-L#{lib}", "-larpack",
                       "-L#{Formula["veclibfort"].opt_lib}", "-lvecLibFort"
    cp_r pkgshare/"testA.mtx", testpath
    assert_match "reached", shell_output("./test")

    if build.with? "mpi"
      cp_r (libexec/"bin").children, testpath
      %w[pcndrv1 pdndrv1 pdndrv3 pdsdrv1
         psndrv1 psndrv3 pssdrv1 pzndrv1].each do |slv|
        system "mpirun", "-np", "4", slv
      end
    end
  end
end

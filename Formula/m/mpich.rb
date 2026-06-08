class Mpich < Formula
  desc "Implementation of the MPI Message Passing Interface standard"
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/5.0.1/mpich-5.0.1.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-5.0.1.tar.gz"
  sha256 "8c1832a13ddacf071685069f5fadfd1f2877a29e1a628652892c65211b1f3327"
  license "mpich2"

  livecheck do
    url "https://www.mpich.org/static/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a2a8add74c70109ba5974c4f84c9a98179a32613eefb525ed5d76f3e3cc0083"
    sha256 cellar: :any,                 arm64_sequoia: "bfb4e7bfbcd5b85c2e08fb56e4d73f98e7bf2412781f40c91b8212d9724581ef"
    sha256 cellar: :any,                 arm64_sonoma:  "9b7819b64c45568bf82cc3ef411f39c5c7ecdaedc6a7dbb31c170a6b76adb85e"
    sha256 cellar: :any,                 sonoma:        "eefa5b660c3420ec269486dd0cc544352cf2ee7ec6e18ca4882e59edfeab46bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adf98998bca6574b1c1549b2c6bd2c89fe63a36044b98309eb2df28d04e4a8a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "543dd5db69f763f595a42a0a983ceab55639ad8ed4aea14cfb33e87875d57171"
  end

  head do
    url "https://github.com/pmodels/mpich.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "gcc" # for gfortran
  depends_on "hwloc"
  uses_from_macos "python" => :build

  on_macos do
    conflicts_with "libfabric", because: "both install `fabric.h`"
  end

  on_linux do
    # Can't be enabled on mac:
    # https://lists.mpich.org/pipermail/discuss/2021-May/006192.html
    depends_on "libfabric"
  end

  conflicts_with "open-mpi", because: "both install MPI compiler wrappers"

  def install
    if build.head?
      # ensure that the consistent set of autotools built by homebrew is used to
      # build MPICH, otherwise very bizarre build errors can occur
      ENV["MPICH_AUTOTOOLS_DIR"] = HOMEBREW_PREFIX + "bin"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-fast=all,O3
      --enable-g=dbg
      --enable-romio
      --enable-shared
      --with-hwloc=#{Formula["hwloc"].opt_prefix}
      --with-pm=hydra
      --prefix=#{prefix}
      --mandir=#{man}
      F77=gfortran
      FC=gfortran
    ]

    if OS.linux?
      # Use libfabric https://lists.mpich.org/pipermail/discuss/2021-January/006092.html
      args << "--with-device=ch4:ofi"
      args << "--with-libfabric=#{Formula["libfabric"].opt_prefix}"
    end

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <mpi.h>
      #include <stdio.h>

      int main()
      {
        int size, rank, nameLen;
        char name[MPI_MAX_PROCESSOR_NAME];
        MPI_Init(NULL, NULL);
        MPI_Comm_size(MPI_COMM_WORLD, &size);
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);
        MPI_Get_processor_name(name, &nameLen);
        printf("[%d/%d] Hello, world! My name is %s.\\n", rank, size, name);
        MPI_Finalize();
        return 0;
      }
    C
    system bin/"mpicc", "hello.c", "-o", "hello"
    system "./hello"
    system bin/"mpirun", "-np", "4", "./hello"

    (testpath/"hellof.f90").write <<~FORTRAN
      program hello
      include 'mpif.h'
      integer rank, size, ierror, tag, status(MPI_STATUS_SIZE)
      call MPI_INIT(ierror)
      call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
      call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
      print*, 'node', rank, ': Hello Fortran world'
      call MPI_FINALIZE(ierror)
      end
    FORTRAN
    system bin/"mpif90", "hellof.f90", "-o", "hellof"
    system "./hellof"
    system bin/"mpirun", "-np", "4", "./hellof"
  end
end

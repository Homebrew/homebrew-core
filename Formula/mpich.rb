class Mpich < Formula
  desc "Implementation of the MPI Message Passing Interface standard"
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/4.0.2/mpich-4.0.2.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-4.0.2.tar.gz"
  sha256 "5a42f1a889d4a2d996c26e48cbf9c595cbf4316c6814f7c181e3320d21dedd42"
  license "mpich2"

  livecheck do
    url "https://www.mpich.org/static/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "407945b2f63e8bb8aa71c435ec43a23927d4c46404808ccc13d857b2919ad3da"
    sha256 cellar: :any,                 arm64_big_sur:  "86597150d3f922c6752b8ac985f091bdd99cf918fc1d15734a1afcacd343012b"
    sha256 cellar: :any,                 monterey:       "17efc3ead6fa899bf9abc11f5f670bdcf672b1a2e9b370188037ae0b41abe928"
    sha256 cellar: :any,                 big_sur:        "7e7b189db2a693edab05d39c1ddaf60702c52285316da30dd6c4879bedee99e7"
    sha256 cellar: :any,                 catalina:       "daa5d28140ac17df92ee6468be59c3f25570120670c239e8867c7ed559370b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd1075a93bb075ccde26a130249d3786275d96d72088d93452b57f2524e94a82"
  end

  head do
    url "https://github.com/pmodels/mpich.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "gcc" # for gfortran
  depends_on "hwloc"

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
      --enable-fast=all,O3
      --enable-g=dbg
      --enable-romio
      --enable-shared
      --with-pm=hydra
      FC=gfortran-#{Formula["gcc"].any_installed_version.major}
      FCFLAGS=-fallow-argument-mismatch
      F77=gfortran-#{Formula["gcc"].any_installed_version.major}
      --disable-silent-rules
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    # Flag for compatibility with GCC 10
    # https://lists.mpich.org/pipermail/discuss/2020-January/005863.html
    args << "FFLAGS=-fallow-argument-mismatch"

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
    (testpath/"hello.c").write <<~EOS
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
    EOS
    system "#{bin}/mpicc", "hello.c", "-o", "hello"
    system "./hello"
    system "#{bin}/mpirun", "-np", "4", "./hello"

    (testpath/"hellof.f90").write <<~EOS
      program hello
      include 'mpif.h'
      integer rank, size, ierror, tag, status(MPI_STATUS_SIZE)
      call MPI_INIT(ierror)
      call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
      call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
      print*, 'node', rank, ': Hello Fortran world'
      call MPI_FINALIZE(ierror)
      end
    EOS
    system "#{bin}/mpif90", "hellof.f90", "-o", "hellof"
    system "./hellof"
    system "#{bin}/mpirun", "-np", "4", "./hellof"
  end
end

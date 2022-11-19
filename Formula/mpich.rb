class Mpich < Formula
  desc "Implementation of the MPI Message Passing Interface standard"
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/4.0.3/mpich-4.0.3.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-4.0.3.tar.gz"
  sha256 "17406ea90a6ed4ecd5be39c9ddcbfac9343e6ab4f77ac4e8c5ebe4a3e3b6c501"
  license "mpich2"

  livecheck do
    url "https://www.mpich.org/static/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3c99cd7ecd50e25a9f6ccb2579376a7aec8709c5752e25e49737e10c29e4ad3f"
    sha256 cellar: :any,                 arm64_monterey: "7eed76ddb0d62be4221f1ac364d64908ae516ea15e0355fadf225359d2711c91"
    sha256 cellar: :any,                 arm64_big_sur:  "4b4ec61f4fe50eca769214f8af6dacd7a1490028e106c1569b2f2bdec60c728b"
    sha256 cellar: :any,                 ventura:        "5680789c31f437df44d463e4107bcf480816570b7757eb9aa0d29c69a5a3416b"
    sha256 cellar: :any,                 monterey:       "ee2e6de58b6d62320f2a11c81cf02a7a7a9c13f20b773f00362b95b13beb8bcb"
    sha256 cellar: :any,                 big_sur:        "2645e5ce868792c38f89d349808ce54b0d350dbc8f94d3922b971299fa574ff4"
    sha256 cellar: :any,                 catalina:       "5d0d4a2f258cc3f6de9bee169e993be158b1e64fad2eb474666cee5c2e5353d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "823398e970d089080dcf33143f5d0e1467fa7e01304e8ddc439320d1bb3c3720"
  end

  head do
    url "https://github.com/pmodels/mpich.git"

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

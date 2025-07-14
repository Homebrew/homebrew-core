class Mpich < Formula
  desc "Implementation of the MPI Message Passing Interface standard"
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/4.3.1/mpich-4.3.1.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-4.3.1.tar.gz"
  sha256 "acc11cb2bdc69678dc8bba747c24a28233c58596f81f03785bf2b7bb7a0ef7dc"
  license "mpich2"

  livecheck do
    url "https://www.mpich.org/static/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "26b19ddaa079c787e0a5665c999a5a5bc3de8a8b75fe4e270cf4728aab122bf1"
    sha256 cellar: :any,                 arm64_sonoma:  "0e2907b9052bd594ef9a9136a93989bc92666f1e2b9099b385e03f50f5d8b7de"
    sha256 cellar: :any,                 arm64_ventura: "10f31ee723eafb5f160ccbbcbc2b8e6526faa7736b362c607b3a8b23a589b37e"
    sha256 cellar: :any,                 sonoma:        "1423b89869d7afe1838bcaa57e2a17a5c251f016fbf8468e4c3ca049d4500d96"
    sha256 cellar: :any,                 ventura:       "342289b771ccbf881a9fc8f54fe8d4e65c907373b5634a5a4e8cb509613238d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a23d4e7f4e6a658e9efa8bf571578e721dbf0c8f2f3444a7657928d2a649ca61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df4b2cf8352ece5365b61ac5988962f85ffdd6b9cdeb9bf28f044729d4e35c4"
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

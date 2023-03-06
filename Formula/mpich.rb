class Mpich < Formula
  desc "Implementation of the MPI Message Passing Interface standard"
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/4.1.1/mpich-4.1.1.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-4.1.1.tar.gz"
  sha256 "ee30471b35ef87f4c88f871a5e2ad3811cd9c4df32fd4f138443072ff4284ca2"
  license "mpich2"

  livecheck do
    url "https://www.mpich.org/static/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e341acad9f0aa46a1b608c266e2b5758d82ecb381c3e3203da949c5ba23e40e"
    sha256 cellar: :any,                 arm64_monterey: "c862543b4a115e3791ce91a2d7e49b67d27be1217306b9261afbea13611b67f7"
    sha256 cellar: :any,                 arm64_big_sur:  "969ac9f09d8eacbe4a41c1709bc9be2b1acaeb4006426b600503c3e8e94b2c03"
    sha256 cellar: :any,                 ventura:        "93cac873004c401ac1e39b6974acc09780c9585e0e507321aa105622cf067c93"
    sha256 cellar: :any,                 monterey:       "3a1ec5b83e3df79148fde43caba1035371d1abdecf5f35b6ab66095e618acfae"
    sha256 cellar: :any,                 big_sur:        "37b11557d5f01027366c3e567dde4277e429367364523648491a777f8bf14fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c437d0b243699f91743f7741e96f849203db75c0ef60fa932c627407b732cf1"
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

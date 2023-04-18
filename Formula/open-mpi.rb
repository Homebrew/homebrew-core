class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.5.tar.bz2"
  sha256 "a640986bc257389dd379886fdae6264c8cfa56bc98b71ce3ae3dfbd8ce61dbe3"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/MPI v?(\d+(?:\.\d+)+) release/i)
  end

  bottle do
    sha256 arm64_ventura:  "89a564cff8b043b4fe5e3d34c2f096ea6bc89cf72e4165fa1b551d29d5a55b88"
    sha256 arm64_monterey: "c5b0561326489ee9e8ba2d6a6281fde4db0355847fd2f940f2163b89e001081b"
    sha256 arm64_big_sur:  "7e246c8147f40a8455fa8cc4b54832f79acd2661173199a4c1e8407ff9d2176d"
    sha256 ventura:        "c96d7b4d63ad9355fbc53f649382b98049bee122b73abf0917cdda475c5dae0f"
    sha256 monterey:       "596abf565b48277a76d71cac98bd9419ea8cefc8135ca22c188f43f2cc0de4eb"
    sha256 big_sur:        "88ca0ebd264ece1fc595c3842226f675ce5a93d4e208c1b2fc5ab4bb79757e17"
    sha256 x86_64_linux:   "5ade70516d7f3b71c9917a0ef8749ede07a50a4b88b388f25954857c650f843a"
  end

  head do
    url "https://github.com/open-mpi/ompi.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gcc" # for gfortran
  depends_on "hwloc"
  depends_on "libevent"

  conflicts_with "mpich", because: "both install MPI compiler wrappers"

  def install
    # Otherwise libmpi_usempi_ignore_tkr gets built as a static library
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # Avoid references to the Homebrew shims directory
    inreplace_files = %w[
      ompi/tools/ompi_info/param.c
      oshmem/tools/oshmem_info/param.c
    ]

    cxx = OS.linux? ? "g++" : ENV.cxx
    inreplace inreplace_files, "OMPI_CXX_ABSOLUTE", "\"#{cxx}\""

    inreplace_files << "orte/tools/orte-info/param.c" unless build.head?
    inreplace_files << "opal/mca/pmix/pmix3x/pmix/src/tools/pmix_info/support.c" unless build.head?

    cc = OS.linux? ? "gcc" : ENV.cc
    inreplace inreplace_files, /(OPAL|PMIX)_CC_ABSOLUTE/, "\"#{cc}\""

    ENV.cxx11
    ENV.runtime_cpu_detection

    args = %W[
      --disable-silent-rules
      --enable-ipv6
      --enable-mca-no-build=reachable-netlink
      --sysconfdir=#{etc}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-sge
    ]
    args << "--with-platform-optimized" if build.head?

    system "./autogen.pl", "--force" if build.head?
    system "./configure", *std_configure_args, *args
    system "make", "all"
    system "make", "check"
    system "make", "install"

    # Fortran bindings install stray `.mod` files (Fortran modules) in `lib`
    # that need to be moved to `include`.
    include.install lib.glob("*.mod")
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
    system bin/"mpicc", "hello.c", "-o", "hello"
    system "./hello"
    system bin/"mpirun", "./hello"
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
    system bin/"mpif90", "hellof.f90", "-o", "hellof"
    system "./hellof"
    system bin/"mpirun", "./hellof"
  end
end

class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.bz2"
  sha256 "92912e175fd1234368c8730c03f4996fe5942e7479bb1d10059405e7f2b3930d"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/MPI v?(\d+(?:\.\d+)+) release/i)
  end

  bottle do
    sha256 arm64_monterey: "1bb1409ae5c8e50698c567c127a71bfaa3459c2f97df8af8c8e930eb82e6a165"
    sha256 arm64_big_sur:  "8385ce6717a4e4996f280bad6049288f56f3a93e55674b09549848e3ca2c603c"
    sha256 monterey:       "722a35b677028c909a951ddaa224c27748aec44dd2256fc20497407a53e83e33"
    sha256 big_sur:        "428ab25bdffdafb06bef18fd058fff400fc9354f1c0ff248f8e5742380572554"
    sha256 catalina:       "20344446ac52a58ceb12623f30fc6e48078fa6b987b7b6235392f891df5f01be"
    sha256 x86_64_linux:   "8f440862d2b4820e1e54b270b855881695bf4447ba45e071745ca956bb3f5aa0"
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

    inreplace inreplace_files, "OMPI_CXX_ABSOLUTE", "\"#{ENV.cxx}\""

    inreplace_files << "orte/tools/orte-info/param.c" unless build.head?
    inreplace_files << "opal/mca/pmix/pmix3x/pmix/src/tools/pmix_info/support.c" unless build.head?

    inreplace inreplace_files, /(OPAL|PMIX)_CC_ABSOLUTE/, "\"#{ENV.cc}\""

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

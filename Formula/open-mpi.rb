class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.4.tar.bz2"
  sha256 "47e24eb2223fe5d24438658958a313b6b7a55bb281563542e1afc9dec4a31ac4"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 "d0fff667ea8857e586804896e548941e21b164a6967ef5b5d4e6f19023e27370" => :catalina
    sha256 "2a7c4fccb0807f159fa0f5b4021214385e7a38cd573a3f0ae8ea59aa96734e58" => :mojave
    sha256 "6ca3b12ced550f1ecf9ba0440a86474d1415691cd14e84e949466c82732a72f2" => :high_sierra
  end

  head do
    url "https://github.com/open-mpi/ompi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gcc"
  depends_on "hwloc"
  depends_on "libevent"

  conflicts_with "mpich", because: "both install MPI compiler wrappers"

  def install
    # otherwise libmpi_usempi_ignore_tkr gets built as a static library
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # Avoid references to the Homebrew shims directory
    %w[
      ompi/tools/ompi_info/param.c
      orte/tools/orte-info/param.c
      oshmem/tools/oshmem_info/param.c
      opal/mca/pmix/pmix3x/pmix/src/tools/pmix_info/support.c
    ].each do |fname|
      inreplace fname, /(OPAL|PMIX)_CC_ABSOLUTE/, "\"#{ENV.cc}\""
    end

    %w[
      ompi/tools/ompi_info/param.c
      oshmem/tools/oshmem_info/param.c
    ].each do |fname|
      inreplace fname, "OMPI_CXX_ABSOLUTE", "\"#{ENV.cxx}\""
    end

    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-ipv6
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-sge
    ]
    args << "--with-platform-optimized" if build.head?

    system "./autogen.pl" if build.head?
    system "./configure", *args
    system "make", "all"
    system "make", "check"
    system "make", "install"

    # Fortran bindings install stray `.mod` files (Fortran modules) in `lib`
    # that need to be moved to `include`.
    include.install Dir["#{lib}/*.mod"]
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

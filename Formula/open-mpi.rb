class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://www.open-mpi.org/software/ompi/v3.1/downloads/openmpi-3.1.1.tar.bz2"
  sha256 "3f11b648dd18a8b878d057e9777f2c43bf78297751ad77ae2cef6db0fe80c77c"

  bottle do
    sha256 "716e46cfa0e361cff9de31ec20f4e534e446ed3b598b59a708e70e9d80b97997" => :high_sierra
    sha256 "bbe4e8ef9e043a04b1084334381857ae0279edd3f74c9b83bdb2411f2d0685d5" => :sierra
    sha256 "4e8304212bb5ea0045974b096f7225c988657831521cc6fd5893a67477b3fb28" => :el_capitan
  end

  head do
    url "https://github.com/open-mpi/ompi.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-mpi-thread-multiple", "Enable MPI_THREAD_MULTIPLE"
  option "with-cxx-bindings", "Enable C++ MPI bindings (deprecated as of MPI-3.0)"
  option "without-fortran", "Do not build the Fortran bindings"

  deprecated_option "disable-fortran" => "without-fortran"
  deprecated_option "enable-mpi-thread-multiple" => "with-mpi-thread-multiple"

  depends_on "gcc" if build.with? "fortran"
  depends_on :java => :optional
  depends_on "libevent"

  conflicts_with "mpich", :because => "both install MPI compiler wrappers"

  needs :cxx11

  def install
    # otherwise libmpi_usempi_ignore_tkr gets built as a static library
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

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
    args << "--disable-mpi-fortran" if build.without? "fortran"
    args << "--enable-mpi-thread-multiple" if build.with? "mpi-thread-multiple"
    args << "--enable-mpi-java" if build.with? "java"
    args << "--enable-mpi-cxx" if build.with? "cxx-bindings"

    system "./autogen.pl" if build.head?
    system "./configure", *args
    system "make", "all"
    system "make", "check"
    system "make", "install"

    # If Fortran bindings were built, there will be stray `.mod` files
    # (Fortran header) in `lib` that need to be moved to `include`.
    include.install Dir["#{lib}/*.mod"] if build.with? "fortran"
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

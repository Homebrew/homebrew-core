class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.3.tar.bz2"
  sha256 "3d81d04c54efb55d3871a465ffb098d8d72c1f48ff1cbaf2580eb058567c0a3b"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/MPI v?(\d+(?:\.\d+)+) release/i)
  end

  bottle do
    sha256 arm64_monterey: "ed4c20df651ef9c71c9f9b9e39db1e7c365aaa50528515bbe81a8b49d146ac3e"
    sha256 arm64_big_sur:  "a96a415cdde33add4d1f4f61d785734df7fd4ac642778b143ad877268a5a9c3a"
    sha256 monterey:       "380caa56100f528862c699244a14747ad66ef8abc109767f6e4573bf561e58a4"
    sha256 big_sur:        "57559e283299c56ef3285bbda752cf9b1a5e1ac22936cbecb41b6ee15b002f82"
    sha256 catalina:       "0605a2da6ef4d646095c1b780311df026207d75d2f3451afaf58174058059122"
    sha256 x86_64_linux:   "3a2969e4feeb5734fba133bd4f496ff9138a847ed0c6707d3d03e3db475dc07a"
  end

  head do
    url "https://github.com/open-mpi/ompi.git"
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
    ENV.runtime_cpu_detection

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-ipv6
      --enable-mca-no-build=reachable-netlink
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-sge
    ]
    args << "--with-platform-optimized" if build.head?

    system "./autogen.pl", "--force" if build.head?
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

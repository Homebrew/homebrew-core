class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.1.tar.bz2"
  sha256 "e24f7a778bd11a71ad0c14587a7f5b00e68a71aa5623e2157bafee3d44c07cda"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :homepage
    regex(/MPI v?(\d+(?:\.\d+)+) release/i)
  end

  bottle do
    sha256 arm64_big_sur: "c24af00250fad2b097822d0d6e51f1027915e375dcbc0590b385b30ef8af6453"
    sha256 monterey:      "0d95be67b57f68afb81d7524098d6a33fb8a9c18538c66f7dbf6b196954f8e3b"
    sha256 big_sur:       "da310195e62c1a27aea7365b325cb15dd48f99dd673fd1f685f8b5247cfbb48d"
    sha256 catalina:      "27f25156376078df9cb6e41a57c370cb030f16092ee7dfe85d7a8000f252240e"
    sha256 mojave:        "4d57102ec2e06043bc97d34130ae5cd9115a6a1718331476f5fbd71d8bef149e"
    sha256 x86_64_linux:  "0c6558437eedbf31810f41163ddff64c610ec5d5065bb4080e2559961ab3668d"
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
    if MacOS.version == :big_sur
      # Fix for current GCC on Big Sur, which does not like 11 as version value
      # (reported at https://github.com/iains/gcc-darwin-arm64/issues/31#issuecomment-750343944)
      ENV["MACOSX_DEPLOYMENT_TARGET"] = "11.0"
    else
      # Otherwise libmpi_usempi_ignore_tkr gets built as a static library
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

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

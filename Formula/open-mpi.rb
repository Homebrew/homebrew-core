class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.bz2"
  sha256 "92912e175fd1234368c8730c03f4996fe5942e7479bb1d10059405e7f2b3930d"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/MPI v?(\d+(?:\.\d+)+) release/i)
  end

  bottle do
    sha256 arm64_monterey: "c6c7bbcc4c1cb911ad45332765571daf6d7dbbd3ecad24d8143ee3648fb98299"
    sha256 arm64_big_sur:  "106128677431abf6253682f754e24bd4b9b20047acded6f16027c530720c11d3"
    sha256 monterey:       "dea48c72da25568d64895b92d338dca17bf98945beca0a7ee38d4c1a20ffac75"
    sha256 big_sur:        "009c7c3922114e87c9579cf5481da1020ac5ab7c4e2c1534067acd8bdf3e3fd7"
    sha256 catalina:       "d83d61116fa13f540aba9da95985b9f61a76e9b835c3838cdee3f6d9b79a1106"
    sha256 x86_64_linux:   "8f98a0c30dcfb168233634311fefb8f9cf16b5a8b84b7d264ef0e24192852ffa"
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
    %w[
      ompi/tools/ompi_info/param.c
      oshmem/tools/oshmem_info/param.c
    ].each do |fname|
      inreplace fname, /(OPAL|PMIX)_CC_ABSOLUTE/, "\"#{ENV.cc}\""
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

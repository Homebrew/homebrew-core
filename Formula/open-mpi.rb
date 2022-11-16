class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.bz2"
  sha256 "92912e175fd1234368c8730c03f4996fe5942e7479bb1d10059405e7f2b3930d"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :homepage
    regex(/MPI v?(\d+(?:\.\d+)+) release/i)
  end

  bottle do
    sha256 arm64_ventura:  "3f61fb90c6a60331c3fe85137b9c975f97a2967433608da6efb4abac3bc22eca"
    sha256 arm64_monterey: "6fce4b7846d2ac61b339fed64109f83fbfe3fca5e29123d219c4aec7264b17b8"
    sha256 arm64_big_sur:  "270edb8b3f965fabae4c6f25136fdd129072a0bb560127ed2a26eef4f7a05953"
    sha256 ventura:        "84a19b52620c7394d79bcda0fc7f742401bd33c9001fcfda2618b76fc7929240"
    sha256 monterey:       "7b119eb6403ba68bc7488400b743dfefb09162a8d094659110a23491782925f6"
    sha256 big_sur:        "e8f418ade2643371972f22ea27dfd1283659b58efaac5e271916961845d00f6f"
    sha256 catalina:       "340edd884d2c78cd6939de7bf859f501f77a3af469aad6a3e05fcee64ac32b7a"
    sha256 x86_64_linux:   "07c71e5e4e4a6fae6bb0fb7ed19c4f50c434478438d6468df62b2ff328a15fcc"
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

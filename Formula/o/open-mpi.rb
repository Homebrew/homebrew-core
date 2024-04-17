class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.3.tar.bz2"
  sha256 "990582f206b3ab32e938aa31bbf07c639368e4405dca196fabe7f0f76eeda90b"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/MPI v?(\d+(?:\.\d+)+) release/i)
  end

  bottle do
    sha256 arm64_sonoma:   "14f9d433b601aa9cb6c072a18fe585214c5684b08711cfbf422ca2ab469ea7e3"
    sha256 arm64_ventura:  "37c3628954f736dccf41af3110ccfeb9fd8c0191b5b3949f72d512c17a98aa05"
    sha256 arm64_monterey: "349c1be9e22da58c890fab40e1ebe85bb0fd059ae8e910ffd359bf4cf8c29448"
    sha256 sonoma:         "d1c7d15b340c353c56809246c9ea834da5ea0cf65967bad5d23f32a278e607e7"
    sha256 ventura:        "3d92d622b3b68cace6bf91d451c49d887a11c37c7319e456aa6fc63d10298c90"
    sha256 monterey:       "750b582c5f009fcf737426b1387ab3432425ebc07c15f14fc3e9dc6f7336596d"
    sha256 x86_64_linux:   "b99d9e2602eeb49ec33c21c6792b921be5ddca9cbbde248924b1bc5e2e6b8d07"
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
  depends_on "pmix"

  conflicts_with "mpich", because: "both install MPI compiler wrappers"

  def install
    if OS.mac?
      # Otherwise libmpi_usempi_ignore_tkr gets built as a static library
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      # Work around asm incompatibility with new linker (FB13194320)
      # https://github.com/open-mpi/ompi/issues/12427
      ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500
    end

    # Avoid references to the Homebrew shims directory
    inreplace_files = %w[
      ompi/tools/ompi_info/param.c
      oshmem/tools/oshmem_info/param.c
    ]
    inreplace_files_cc = %w[
      3rd-party/openpmix/src/tools/pmix_info/support.c
      3rd-party/prrte/src/tools/prte_info/param.c
    ]

    cxx = OS.linux? ? "g++" : ENV.cxx
    inreplace inreplace_files, "OMPI_CXX_ABSOLUTE", "\"#{cxx}\""

    cc = OS.linux? ? "gcc" : ENV.cc
    inreplace inreplace_files, /(OPAL|PMIX)_CC_ABSOLUTE/, "\"#{cc}\""
    inreplace inreplace_files_cc, /(PMIX|PRTE)_CC_ABSOLUTE/, "\"#{cc}\""

    ENV.cxx11
    ENV.runtime_cpu_detection

    args = %W[
      --disable-silent-rules
      --enable-ipv6
      --enable-mca-no-build=reachable-netlink
      --sysconfdir=#{etc}
      --with-hwloc=#{Formula["hwloc"].opt_prefix}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-pmix=#{Formula["pmix"].opt_prefix}
      --with-sge
    ]
    args << "--with-platform-optimized" if build.head?

    # Work around asm incompatibility with new linker (FB13194320)
    # https://github.com/open-mpi/ompi/issues/11935
    args << "--with-wrapper-ldflags=-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    system "./autogen.pl", "--force" if build.head?
    system "./configure", *std_configure_args, *args
    system "make", "all"
    system "make", "check"
    system "make", "install"

    # Fortran bindings install stray `.mod` files (Fortran modules) in `lib`
    # that need to be moved to `include`.
    include.install lib.glob("*.mod")

    # Avoid references to cellar paths.
    inreplace (lib/"pkgconfig").glob("*.pc"), prefix, opt_prefix, false
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
    system bin/"mpifort", "hellof.f90", "-o", "hellof"
    system "./hellof"
    system bin/"mpirun", "./hellof"

    (testpath/"hellousempi.f90").write <<~EOS
      program hello
      use mpi
      integer rank, size, ierror, tag, status(MPI_STATUS_SIZE)
      call MPI_INIT(ierror)
      call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
      call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
      print*, 'node', rank, ': Hello Fortran world'
      call MPI_FINALIZE(ierror)
      end
    EOS
    system bin/"mpifort", "hellousempi.f90", "-o", "hellousempi"
    system "./hellousempi"
    system bin/"mpirun", "./hellousempi"

    (testpath/"hellousempif08.f90").write <<~EOS
      program hello
      use mpi_f08
      integer rank, size, tag, status(MPI_STATUS_SIZE)
      call MPI_INIT()
      call MPI_COMM_SIZE(MPI_COMM_WORLD, size)
      call MPI_COMM_RANK(MPI_COMM_WORLD, rank)
      print*, 'node', rank, ': Hello Fortran world'
      call MPI_FINALIZE()
      end
    EOS
    system bin/"mpifort", "hellousempif08.f90", "-o", "hellousempif08"
    system "./hellousempif08"
    system bin/"mpirun", "./hellousempif08"
  end
end

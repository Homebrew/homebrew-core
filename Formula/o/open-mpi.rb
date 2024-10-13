class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.5.tar.bz2"
  sha256 "6588d57c0a4bd299a24103f4e196051b29e8b55fbda49e11d5b3d32030a32776"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/MPI v?(\d+(?:\.\d+)+) release/i)
  end

  bottle do
    sha256 arm64_sequoia: "e0235a4d1d504248e8d736e9ad92b785789b06c26d5f6634168ba0bf31fd9bce"
    sha256 arm64_sonoma:  "522592a0f5a23e7b719808ec3f61abcbb0c6f046356ab23c24de4ff948c616f2"
    sha256 arm64_ventura: "42ef2bda5d4586176bdd9046d2cfb235b4cd8bf3fdab09c2f65d84af52977cfd"
    sha256 sonoma:        "d38cae4c45c360f7d5e0b536ae0f792d3b7363c895acc2c60519b64685fed2f2"
    sha256 ventura:       "624f0f7c7be4be5ad2d89b583d2b0294c70fedd89ed33552f5a7fe1061262638"
    sha256 x86_64_linux:  "08d155c685dfe497ceecf98d4d703e19af6643bca8ce1981ddc38ae6dbb6a752"
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
    # Backport https://github.com/open-mpi/ompi/commit/2d3ad2b2a777ffe70511426808a5c5ca5693c443
    # TODO: Remove on the next release (inreplace will fail)
    inreplace "configure", "$LDFLAGS_xcode_save", "$LDFLAGS_save_xcode" if build.stable?

    ENV.runtime_cpu_detection
    # Otherwise libmpi_usempi_ignore_tkr gets built as a static library
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?

    # Remove bundled copies of libraries that shouldn't be used
    unbundled_packages = %w[hwloc libevent openpmix].join(",")
    rm_r Dir["3rd-party/{#{unbundled_packages}}*"]

    # Avoid references to the Homebrew shims directory
    inreplace_files = %w[
      ompi/tools/ompi_info/param.c
      oshmem/tools/oshmem_info/param.c
    ]
    cxx = OS.linux? ? "g++" : ENV.cxx
    cc = OS.linux? ? "gcc" : ENV.cc
    inreplace inreplace_files, "OMPI_CXX_ABSOLUTE", "\"#{cxx}\""
    inreplace inreplace_files, "OPAL_CC_ABSOLUTE", "\"#{cc}\""
    inreplace "3rd-party/prrte/src/tools/prte_info/param.c", "PRTE_CC_ABSOLUTE", "\"#{cc}\""

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

    if build.head?
      args << "--with-platform-optimized"
      system "./autogen.pl", "--force", "--no-3rdparty=#{unbundled_packages}"
    end

    system "./configure", *args, *std_configure_args
    system "make", "all"
    system "make", "check"
    system "make", "install"

    # Fortran bindings install stray `.mod` files (Fortran modules) in `lib`
    # that need to be moved to `include`.
    include.install lib.glob("*.mod")

    # Avoid references to cellar paths.
    inreplace (lib/"pkgconfig").glob("*.pc"), prefix, opt_prefix, audit_result: false
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

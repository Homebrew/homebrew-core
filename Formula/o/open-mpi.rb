class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.6.tar.bz2"
  sha256 "bd4183fcbc43477c254799b429df1a6e576c042e74a2d2f8b37d537b2ff98157"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/MPI v?(\d+(?:\.\d+)+) release/i)
  end

  bottle do
    sha256 arm64_sequoia: "c01948d46a7d4f21ae3e525edb3ef2c11a416ce754fa3afada59837b1aa6cfab"
    sha256 arm64_sonoma:  "1b9c17dfafe3b8c4baa45936e0ab4a0b5ce53a1d21a1350d5bbf50e513ab395b"
    sha256 arm64_ventura: "cde2b091f98b364ba6a8ea46015b2c3ca42fa6bb098a9609a0f8153971a43adb"
    sha256 sonoma:        "25f8974a2c5ead1a0ec5a3e39a6b577c7ae86b2b4126554124f9279f01c4f53e"
    sha256 ventura:       "3104a3972cb1f7ed08486a2656f88266e8d4a7f8fc6d8e325085a3cdbc94c98c"
    sha256 x86_64_linux:  "192b5a87453c9389c8203c1651b693b2c98e50d1c4c559674a7c1232240436d6"
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

    # Avoid conflict with PuTTY similar to Arch Linux[^1]. May be able to remove with PRRTE v4[^2]
    #
    # [^1]: https://gitlab.archlinux.org/archlinux/packaging/packages/prrte/-/blob/main/PKGBUILD?ref_type=heads#L98
    # [^2]: https://github.com/openpmix/prrte/issues/1836
    bin.install bin/"pterm" => "prrte-pterm"
    man1.install man1/"pterm.1" => "prrte-pterm.1"
  end

  def caveats
    "`pterm` has been renamed to `prrte-pterm` to avoid conflict with `putty`"
  end

  test do
    (testpath/"hello.c").write <<~'C'
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
        printf("[%d/%d] Hello, world! My name is %s.\n", rank, size, name);
        MPI_Finalize();
        return 0;
      }
    C
    system bin/"mpicc", "hello.c", "-o", "hello"
    system "./hello"
    system bin/"mpirun", "./hello"
    (testpath/"hellof.f90").write <<~FORTRAN
      program hello
      include 'mpif.h'
      integer rank, size, ierror, tag, status(MPI_STATUS_SIZE)
      call MPI_INIT(ierror)
      call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
      call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
      print*, 'node', rank, ': Hello Fortran world'
      call MPI_FINALIZE(ierror)
      end
    FORTRAN
    system bin/"mpifort", "hellof.f90", "-o", "hellof"
    system "./hellof"
    system bin/"mpirun", "./hellof"

    (testpath/"hellousempi.f90").write <<~FORTRAN
      program hello
      use mpi
      integer rank, size, ierror, tag, status(MPI_STATUS_SIZE)
      call MPI_INIT(ierror)
      call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
      call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
      print*, 'node', rank, ': Hello Fortran world'
      call MPI_FINALIZE(ierror)
      end
    FORTRAN
    system bin/"mpifort", "hellousempi.f90", "-o", "hellousempi"
    system "./hellousempi"
    system bin/"mpirun", "./hellousempi"

    (testpath/"hellousempif08.f90").write <<~FORTRAN
      program hello
      use mpi_f08
      integer rank, size, tag, status(MPI_STATUS_SIZE)
      call MPI_INIT()
      call MPI_COMM_SIZE(MPI_COMM_WORLD, size)
      call MPI_COMM_RANK(MPI_COMM_WORLD, rank)
      print*, 'node', rank, ': Hello Fortran world'
      call MPI_FINALIZE()
      end
    FORTRAN
    system bin/"mpifort", "hellousempif08.f90", "-o", "hellousempif08"
    system "./hellousempif08"
    system bin/"mpirun", "./hellousempif08"
  end
end

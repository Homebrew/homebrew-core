class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.9.tar.bz2"
  sha256 "dfb72762531170847af3e4a0f21d77d7b23cf36f67ce7ce9033659273677d80b"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/MPI v?(\d+(?:\.\d+)+) release/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "cd28d2c171ababacf625797283aa0bf5e8320afb6153457a6f90388c4f1d4473"
    sha256 arm64_sequoia: "eeed54525cd950a5a5d008b7511277e20c3a50eb762f45d160fd6c9de8c835d3"
    sha256 arm64_sonoma:  "ddbff35130a0e77b5f8f5f4c503e929a510ce1c2949f6efa5a262f2fdb224526"
    sha256 sonoma:        "77763194eeb86e1c20cc2fc7256bfe9c0b16eb8451c180b5957ddb7c2faee37c"
    sha256 arm64_linux:   "fdde5d8440a00a052b04cd9925cbda0a3df436e9a15dad8e57e851656a3da32f"
    sha256 x86_64_linux:  "05ac59d4efcfb8b0b77bdab7daf261c7639f62e9c48caa7c05d634457b3c9b99"
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
      --with-hwloc=#{formula_opt_prefix("hwloc")}
      --with-libevent=#{formula_opt_prefix("libevent")}
      --with-pmix=#{formula_opt_prefix("pmix")}
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

    # Avoid conflict with `putty` by renaming pterm to prte-term which matches
    # upstream change[^1]. In future release, we may want to split out `prrte`
    # to a separate formula and pass `--without-legacy-names`[^2].
    #
    # [^1]: https://github.com/openpmix/prrte/issues/1836#issuecomment-2564882033
    # [^2]: https://github.com/openpmix/prrte/blob/master/config/prte_configure_options.m4#L390-L393
    odie "Update configure for PRRTE or split to separate formula as prte-term exists" if (bin/"prte-term").exist?
    bin.install bin/"pterm" => "prte-term"
    man1.install man1/"pterm.1" => "prte-term.1"
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

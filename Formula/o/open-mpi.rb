class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.8.tar.bz2"
  sha256 "53131e1a57e7270f645707f8b0b65ba56048f5b5ac3f68faabed3eb0d710e449"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/MPI v?(\d+(?:\.\d+)+) release/i)
  end

  bottle do
    sha256 arm64_sequoia: "ffda541a4f3b0f37e853066cdde31ab459834d0ded4f0e03ab4a74a8dafd6485"
    sha256 arm64_sonoma:  "e54a983c2ec3d1874e77a31415796679f8d98d3f3eb2cd41b1ae463578ec53dd"
    sha256 arm64_ventura: "16bc25d567ddbac27e2f16a99ce21ef2e8d54d63faad081e53641bb4db3c112f"
    sha256 sonoma:        "acbcc6242c6e83f4b6b33a9344b3f679baae17513fb11edf84ab0871ae167583"
    sha256 ventura:       "416dc2ed96d4d4a7316af6594fdda738f382267e3df4763fad3dd8f0494e9b09"
    sha256 arm64_linux:   "e6c70ba970934f26f5edb035307b7b038297d4e730e8aa7b22fc10c7ff1fc56b"
    sha256 x86_64_linux:  "deafa0230ee6bef316836fe9b2a3e73a2298f0c15c10b3356ff45c5390eb1af9"
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

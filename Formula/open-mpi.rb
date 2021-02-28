class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  license "BSD-3-Clause"

  stable do
    url "https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.0.tar.bz2"
    sha256 "73866fb77090819b6a8c85cb8539638d37d6877455825b74e289d647a39fd5b5"

    if Hardware::CPU.arm?
      # Dependencies needed for patch. Remove at next release.
      depends_on "autoconf" => :build
      depends_on "automake" => :build
      depends_on "libtool" => :build

      # Patch to fix ARM build. Remove at next release.
      # https://github.com/open-mpi/ompi/pull/8421
      patch do
        url "https://github.com/open-mpi/ompi/commit/4779d8e079314ffd4556e3cb3289fecd07646cc5.patch?full_index=1"
        sha256 "0553ffcc813919ee06937156073fc18ef6b55fa58201a9cba5168f35f7040c66"
      end
    end
  end

  livecheck do
    url :homepage
    regex(/MPI v?(\d+(?:\.\d+)+) release/i)
  end

  bottle do
    sha256 arm64_big_sur: "6134b45b6faa235377c5cd017b58393a0a124936c81a14da9902604671143ca8"
    sha256 big_sur:       "2afe47eb2c9664599a1bf8687d0244a9b9067bc96e3de184cdee8e3110fa8012"
    sha256 catalina:      "fd21d8d449c7fee6126f11994b6e0d12178b1eab55cbb17f99056d535cb1ace4"
    sha256 mojave:        "f3a7dca683792a4fe866b62004351b1dae6acf2376609cf36bdc771d9e9104ef"
    sha256 high_sierra:   "33d3cd119f7f7d7d3154d758cc0ad68ad513624c9a648c9b87d732ea6a8e6068"
  end

  head do
    url "https://github.com/open-mpi/ompi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gcc"
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
      --enable-mca-no-build=op-avx,reachable-netlink
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-sge
    ]
    args << "--with-platform-optimized" if build.head?

    # Remove ` || Hardware::CPU.arm?` in the next release
    system "./autogen.pl", "--force" if build.head? || Hardware::CPU.arm?
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

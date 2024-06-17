class Mpich < Formula
  desc "Implementation of the MPI Message Passing Interface standard"
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/4.2.1/mpich-4.2.1.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-4.2.1.tar.gz"
  sha256 "23331b2299f287c3419727edc2df8922d7e7abbb9fd0ac74e03b9966f9ad42d7"
  license "mpich2"

  livecheck do
    url "https://www.mpich.org/static/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d67fb5456d6c278f43128f1a008a3b7e39e3fc130fdef2aa135f2b759ab667d6"
    sha256 cellar: :any,                 arm64_ventura:  "1392f8832b3fbab06df08711b6349fe5164eaa1fb65e07f08a4af36326169621"
    sha256 cellar: :any,                 arm64_monterey: "6a96f37e13710724f1fa111db32054a690280a27e9324faca645093f44a64bd3"
    sha256 cellar: :any,                 sonoma:         "97ff3b760e349f2cc29e1d231e215d1eb49ad0cf0bd1d56516fcc90863848e7e"
    sha256 cellar: :any,                 ventura:        "57351d818cd883ea13c5a547fe288f6f3690b4d8dcaa5b78f7b9956906672acb"
    sha256 cellar: :any,                 monterey:       "e6311304eb40d0e0e0c739600e198263e6141afb5c934fbae473c1da87f2cd93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527a2cc4b059ac550873aea0afe6eb81b964d0afa6b6c9c6af2bb3ce8954089c"
  end

  head do
    url "https://github.com/pmodels/mpich.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "gcc" # for gfortran
  depends_on "hwloc"
  uses_from_macos "python" => :build

  on_macos do
    conflicts_with "libfabric", because: "both install `fabric.h`"
  end

  on_linux do
    # Can't be enabled on mac:
    # https://lists.mpich.org/pipermail/discuss/2021-May/006192.html
    depends_on "libfabric"
  end

  conflicts_with "open-mpi", because: "both install MPI compiler wrappers"

  def install
    if build.head?
      # ensure that the consistent set of autotools built by homebrew is used to
      # build MPICH, otherwise very bizarre build errors can occur
      ENV["MPICH_AUTOTOOLS_DIR"] = HOMEBREW_PREFIX + "bin"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-fast=all,O3
      --enable-g=dbg
      --enable-romio
      --enable-shared
      --with-hwloc=#{Formula["hwloc"].opt_prefix}
      --with-pm=hydra
      --prefix=#{prefix}
      --mandir=#{man}
      F77=gfortran
      FC=gfortran
    ]

    if OS.linux?
      # Use libfabric https://lists.mpich.org/pipermail/discuss/2021-January/006092.html
      args << "--with-device=ch4:ofi"
      args << "--with-libfabric=#{Formula["libfabric"].opt_prefix}"
    end

    system "./configure", *args

    system "make"
    system "make", "install"
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
    system "#{bin}/mpicc", "hello.c", "-o", "hello"
    system "./hello"
    system "#{bin}/mpirun", "-np", "4", "./hello"

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
    system "#{bin}/mpif90", "hellof.f90", "-o", "hellof"
    system "./hellof"
    system "#{bin}/mpirun", "-np", "4", "./hellof"
  end
end

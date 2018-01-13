class Mpich < Formula
  desc "Implementation of the MPI Message Passing Interface standard"
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-3.2.1.tar.gz"
  sha256 "5db53bf2edfaa2238eb6a0a5bc3d2c2ccbfbb1badd79b664a1a919d2ce2330f1"
  revision 1

  bottle do
    sha256 "bab0862c4f607c8f411d16b754fb6474f536c5340c2d1c9be4a339ca4a6d9bf9" => :high_sierra
    sha256 "bfb708826242dd9e27ce8c46bba866cbec2c95ee6db419c56e7942c32a88b3b3" => :sierra
    sha256 "214e469d1b5bdbdc685cc31a53e8673880640a2551274c8f06c08b347db7ee54" => :el_capitan
  end

  devel do
    url "https://www.mpich.org/static/downloads/3.3a2/mpich-3.3a2.tar.gz"
    sha256 "5d408e31917c5249bf5e35d1341afc34928e15483473dbb4e066b76c951125cf"
  end

  head do
    url "http://git.mpich.org/mpich.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "gcc" # for gfortran

  conflicts_with "open-mpi", :because => "both install MPI compiler wrappers"

  def install
    if build.head?
      # ensure that the consistent set of autotools built by homebrew is used to
      # build MPICH, otherwise very bizarre build errors can occur
      ENV["MPICH_AUTOTOOLS_DIR"] = HOMEBREW_PREFIX + "bin"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    system "make"
    system "make", "check"
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

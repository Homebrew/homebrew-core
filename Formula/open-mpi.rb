class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://www.open-mpi.org/software/ompi/v2.0/downloads/openmpi-2.0.1.tar.bz2"
  sha256 "fed74f4ae619b7ebcc18150bb5bdb65e273e14a8c094e78a3fea0df59b9ff8ff"

  # Patch Open MPI in order to fallback to oob/tcp when a Unix socket path
  # is too long, and instead of silently truncating the path.
  # This frequently occurs on OSX when both $TMPDIR and hostname are "long"
  patch do
    url "https://github.com/open-mpi/ompi/pull/2135.patch"
    sha256 "35005a892ec1321fa7b6f427967e15e7a83cce0421043a3f42653675be9a24bd"
  end

  bottle do
    sha256 "b2542fee9f047c5a559ebb30836ee50bacc11165848af346d15a6c5a80a669da" => :sierra
    sha256 "ae42aeebda77ce68836d690f6859f662da0a325236f539c6fb433475bfd56e8e" => :el_capitan
    sha256 "b3bdf8a6540d8ac08a105babdd84ef74837856c265ac81f0be43cd84cbc1e849" => :yosemite
    sha256 "df6db5f23211a489b27a5c834bf59cf3f0aa10688871bdfed588e94d87ada5a3" => :mavericks
  end

  head do
    url "https://github.com/open-mpi/ompi.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-mpi-thread-multiple", "Enable MPI_THREAD_MULTIPLE"
  option "with-cxx-bindings", "Enable C++ MPI bindings (deprecated as of MPI-3.0)"
  option :cxx11

  deprecated_option "disable-fortran" => "without-fortran"
  deprecated_option "enable-mpi-thread-multiple" => "with-mpi-thread-multiple"

  depends_on :fortran => :recommended
  depends_on :java => :optional
  depends_on "libevent"

  conflicts_with "mpich", :because => "both install mpi__ compiler wrappers"
  conflicts_with "lcdf-typetools", :because => "both install same set of binaries."

  def install
    ENV.cxx11 if build.cxx11?

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-ipv6
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-sge
    ]
    args << "--with-platform-optimized" if build.head?
    args << "--disable-mpi-fortran" if build.without? "fortran"
    args << "--enable-mpi-thread-multiple" if build.with? "mpi-thread-multiple"
    args << "--enable-mpi-java" if build.with? "java"
    args << "--enable-mpi-cxx" if build.with? "cxx-bindings"

    system "./autogen.pl" if build.head?
    system "./configure", *args
    system "make", "all"
    system "make", "check"
    system "make", "install"

    # If Fortran bindings were built, there will be stray `.mod` files
    # (Fortran header) in `lib` that need to be moved to `include`.
    if build.with? "fortran"
      include.install Dir["#{lib}/*.mod"]
    end
  end

  test do
    (testpath/"hello.c").write <<-EOS.undent
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
    system bin/"mpirun", "-np", "4", "./hello"
    (testpath/"hellof.f90").write <<-EOS.undent
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
    system bin/"mpirun", "-np", "4", "./hellof"
  end
end

class OpenMpiAT16 < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://www.open-mpi.org/software/ompi/v1.6/downloads/openmpi-1.6.5.tar.bz2"
  sha256 "fe37bab89b5ef234e0ac82dc798282c2ab08900bf564a1ec27239d3f1ad1fc85"

  bottle do
    sha256 "ae8d527e2b9802f27001c5b1a4a64e215208b9fc6af7b6a118f9fb7b042d0f05" => :sierra
    sha256 "77ebcca1ed3f06a7a8d3db0b9b4dc45e79eed9c3e3dd02712d39a3e1f057ad27" => :el_capitan
    sha256 "592617bbe7ed6037d66c7548008b1eff9b29293541515ec32a8b01af334ac150" => :yosemite
  end

  keg_only :versioned_formula

  option "without-fortran", "Do not build the Fortran bindings"
  option "with-mpi-thread-multiple", "Enable MPI_THREAD_MULTIPLE"

  deprecated_option "disable-fortran" => "without-fortran"
  deprecated_option "enable-mpi-thread-multiple" => "with-mpi-thread-multiple"

  depends_on :fortran => :recommended

  # Fixes error in tests, which makes them fail on clang.
  # Upstream ticket: https://svn.open-mpi.org/trac/ompi/ticket/4255
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-ipv6
    ]

    args << "--disable-mpi-f77" << "--disable-mpi-f90" if build.without? "fortran"
    args << "--enable-mpi-thread-multiple" if build.with? "mpi-thread-multiple"

    system "./configure", *args
    system "make", "all"
    system "make", "check"
    system "make", "install"

    # If Fortran bindings were built, there will be a stray `.mod` file
    # (Fortran header) in `lib` that needs to be moved to `include`.
    include.install lib/"mpi.mod" if File.exist? "#{lib}/mpi.mod"

    # Not sure why the wrapped script has a jar extension - adamv
    libexec.install bin/"vtsetup.jar"
    bin.write_jar_script libexec/"vtsetup.jar", "vtsetup.jar"
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

    system "#{bin}/mpicc", "hello.c", "-o", "hello"
    system "./hello"
    system "#{bin}/mpirun", "-np", "4", "./hello"
  end
end

__END__
diff --git a/test/datatype/ddt_lib.c b/test/datatype/ddt_lib.c
index 015419d..c349384 100644
--- a/test/datatype/ddt_lib.c
+++ b/test/datatype/ddt_lib.c
@@ -209,7 +209,7 @@ int mpich_typeub2( void )

 int mpich_typeub3( void )
 {
-   int blocklen[2], err = 0, idisp[3];
+   int blocklen[3], err = 0, idisp[3];
    size_t sz;
    MPI_Aint disp[3], lb, ub, ex;
    ompi_datatype_t *types[3], *dt1, *dt2, *dt3, *dt4, *dt5;
diff --git a/test/datatype/opal_ddt_lib.c b/test/datatype/opal_ddt_lib.c
index 4491dcc..b58136d 100644
--- a/test/datatype/opal_ddt_lib.c
+++ b/test/datatype/opal_ddt_lib.c
@@ -761,7 +761,7 @@ int mpich_typeub2( void )

 int mpich_typeub3( void )
 {
-   int blocklen[2], err = 0, idisp[3];
+   int blocklen[3], err = 0, idisp[3];
    size_t sz;
    OPAL_PTRDIFF_TYPE disp[3], lb, ub, ex;
    opal_datatype_t *types[3], *dt1, *dt2, *dt3, *dt4, *dt5;

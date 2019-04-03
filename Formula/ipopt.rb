class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://projects.coin-or.org/Ipopt/"
  url "https://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.12.tgz"
  sha256 "7baeb713ef8d1999bed397b938e9654b38ad536406634384455372dd7e4ed61f"
  head "https://github.com/coin-or/Ipopt.git"

  depends_on "gcc"

  resource "mumps" do
    url "http://mumps.enseeiht.fr/MUMPS_5.1.2.tar.gz"
    sha256 "eb345cda145da9aea01b851d17e54e7eef08e16bfa148100ac1f7f046cd42ae9"

    # MUMPS does not provide a Makefile.inc customized for macOS.
    patch :DATA
  end

  def install
    ENV.delete("MPICC")
    ENV.delete("MPICXX")
    ENV.delete("MPIFC")

    resource("mumps").stage do
      cp "Make.inc/Makefile.inc.generic.SEQ", "Makefile.inc"
      inreplace "Makefile.inc", "@rpath/", "#{opt_lib}/"

      ENV.deparallelize { system "make", "d" }

      (buildpath/"mumps_include").install Dir["include/*.h", "libseq/mpi.h"]
      lib.install Dir["lib/*.dylib", "libseq/*.dylib", "PORD/lib/*.dylib"]
    end

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--enable-shared",
      "--prefix=#{prefix}",
      "--with-mumps-incdir=#{buildpath}/mumps_include",
      "--with-mumps-lib=-L#{lib} -ldmumps -lmpiseq -lmumps_common -lpord",
    ]

    system "./configure", *args
    system "make"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <IpIpoptApplication.hpp>
      #include <IpReturnCodes.hpp>
      #include <IpSmartPtr.hpp>
      int main() {
        Ipopt::SmartPtr<Ipopt::IpoptApplication> app = IpoptApplicationFactory();
        const Ipopt::ApplicationReturnStatus status = app->Initialize();
        assert(status == Ipopt::Solve_Succeeded);
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}/coin", "-L#{lib}", "-lipopt"
    system "./a.out"
  end
end

__END__
diff --git a/Make.inc/Makefile.inc.generic.SEQ b/Make.inc/Makefile.inc.generic.SEQ
index bb27718..61ddf21 100644
--- a/Make.inc/Makefile.inc.generic.SEQ
+++ b/Make.inc/Makefile.inc.generic.SEQ
@@ -97 +97 @@ PLAT    =
-LIBEXT  = .a
+LIBEXT  = .dylib
@@ -103 +102,0 @@ RM      = /bin/rm -f
-CC      = cc
@@ -105 +104 @@ CC      = cc
-FC      = f90
+FC      = gfortran
@@ -107 +106 @@ FC      = f90
-FL      = f90
+FL      = $(FC)
@@ -110 +109 @@ FL      = f90
-AR      = ar vr 
+AR      = $(FC) -dynamiclib -undefined dynamic_lookup -Wl,-install_name,@rpath/$(notdir $@) -o 
@@ -113,2 +112 @@ AR      = ar vr
-RANLIB  = ranlib
-#RANLIB  = echo
+RANLIB  = echo
@@ -146,2 +144,2 @@ CDEFS = -DAdd_
-OPTF    = -O
-OPTC    = -O -I.
+OPTF    = -fPIC -O
+OPTC    = -fPIC -O -I.

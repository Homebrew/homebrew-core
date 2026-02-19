class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  license "GPL-3.0-or-later"
  revision 2
  head "https://git.dynare.org/Dynare/dynare.git", branch: "master"

  stable do
    url "https://www.dynare.org/release/source/dynare-6.5.tar.xz"
    sha256 "56a6f934f5d2ded57206d2f109975324b39586394f4e8ce23b3c72aadcd5cd4a"

    # backport fix for finding suite-sparse
    # https://git.dynare.org/Dynare/dynare/-/commit/b3a50696bf7b8ef97cd8900c4941b479fd27dd2e
    patch :DATA
  end

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dc134e24cfec558ec656922f57084189483493291b2bf9642fef3c48df043034"
    sha256 cellar: :any, arm64_sequoia: "b52fa22efd2173dd73b63854ec2571d8c6241ad72dfbee53492a01c8c7102790"
    sha256 cellar: :any, arm64_sonoma:  "2b00d6af8fa2389af4abb060745d8b4743e13e3d5860e16a5811b2a5d0f94e9d"
    sha256 cellar: :any, sonoma:        "8d4ebac67c8efa3dde83d3d5e5102c3dbdce67732acd9167d527a0d77d70b78f"
    sha256               arm64_linux:   "27d50a92a985e9c5aa32575fd8b05509e17aaed6f90af582bdcb50a12704a343"
    sha256               x86_64_linux:  "7e7fc5e2c8e7009c16d6660020343495d96c050b3e8e80e5a978acfa7cf4cb8c"
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gcc" # for gfortran
  depends_on "gsl"
  depends_on "libmatio"
  depends_on "octave"
  depends_on "openblas"
  depends_on "slicot"
  depends_on "suite-sparse"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "libomp"

    # Work around LLVM issue with structured bindings[^1] by partly reverting commit[^2].
    # Upstream isn't planning to support Clang build[^3] but we need it to use a consistent OpenMP.
    # [^1]: https://github.com/llvm/llvm-project/issues/33025
    # [^2]: https://git.dynare.org/Dynare/dynare/-/commit/6ff7d4c56c26a2b7546de633dbcfe2f163bf846d
    # [^3]: https://git.dynare.org/Dynare/dynare/-/issues/1977
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/c49717c390cb2e587793b2db757c1f445f096219/Patches/dynare/clang.diff"
      sha256 "2d174336fc8db4d8989cda214a972ef49c6302bb12a64d717140869e546e17d0"
    end
  end

  on_sequoia do
    depends_on xcode: ["26.0", :build] # for std::jthreads
  end

  fails_with :clang do
    build 1699
    cause "needs C++20 std::jthreads"
  end

  def install
    # This needs a bit of extra help in finding the Octave libraries on Linux.
    octave = Formula["octave"]
    ENV.append "LDFLAGS", "-Wl,-rpath,#{octave.opt_lib}/octave/#{octave.version.major_minor_patch}" if OS.linux?

    system "meson", "setup", "build", "-Dbuild_for=octave", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    (pkgshare/"examples").install "examples/bkk.mod"
  end

  def caveats
    <<~EOS
      To get started with Dynare, open Octave and type
        addpath #{opt_lib}/dynare/matlab
    EOS
  end

  test do
    resource "statistics" do
      url "https://github.com/gnu-octave/statistics/archive/refs/tags/release-1.7.3.tar.gz", using: :nounzip
      sha256 "570d52af975ea9861a6fb024c23fc0f403199e4b56d7a883ee6ca17072e26990"
    end

    ENV.delete "CXX" # avoid overriding Octave flags
    ENV.delete "LDFLAGS" # avoid overriding Octave flags

    statistics = resource("statistics")
    testpath.install statistics

    cp pkgshare/"examples/bkk.mod", testpath

    # Replace `makeinfo` with dummy command `true` to prevent generating docs
    # that are not useful to the test.
    (testpath/"dyn_test.m").write <<~MATLAB
      makeinfo_program true
      pkg prefix #{testpath}/octave
      pkg install statistics-release-#{statistics.version}.tar.gz
      dynare bkk.mod console
    MATLAB

    system Formula["octave"].opt_bin/"octave", "--no-gui",
           "--no-history", "--path", "#{lib}/dynare/matlab", "dyn_test.m"
  end
end

__END__
diff --git a/meson.build b/meson.build
index 435293bae021218d63aaf5c88e7ef8d9ad0a3762..7256ff96ff5693423099ae0e4d8143ceb7266194 100644
--- a/meson.build
+++ b/meson.build
@@ -260,21 +260,9 @@ else # Octave build
   lapack_dep = declare_dependency(link_args : run_command(mkoctfile_exe, '-p', 'LAPACK_LIBS', check : true).stdout().split(),
                                   dependencies : blas_dep)
 
-  # Create a dependency object for UMFPACK.
-  # The dependency returned by find_library('umfpack') is not enough, because we also want the define
-  # that indicates the location of umfpack.h, so we construct a new dependency object.
-  if cpp_compiler.has_header('suitesparse/umfpack.h', args : octave_incflags)
-    umfpack_def = '-DHAVE_SUITESPARSE_UMFPACK_H'
-  elif cpp_compiler.has_header('umfpack.h', args : octave_incflags)
-    umfpack_def = '-DHAVE_UMFPACK_H'
-  else
-    error('Can’t find umfpack.h')
-  endif
   # Do not enforce static linking even if prefer_static is true, since that library is shipped
   # with Octave.
-  # The “dirs” argument is useful when cross-compiling.
-  umfpack_dep_tmp = cpp_compiler.find_library('umfpack', dirs : octlibdir / '../..', static : false)
-  umfpack_dep = declare_dependency(compile_args : umfpack_def, dependencies : [ umfpack_dep_tmp, blas_dep ])
+  umfpack_dep = dependency('UMFPACK', static : false)
 
   # This library does not exist under Octave
   ut_dep = []
diff --git a/mex/sources/dynumfpack.h b/mex/sources/dynumfpack.h
index ae3e11c94be51cbf9ee7249db80526712e55e469..c73fa5f8c0b1ab50b9e1b165719e27f1278f1ca8 100644
--- a/mex/sources/dynumfpack.h
+++ b/mex/sources/dynumfpack.h
@@ -25,12 +25,7 @@
 #define DYNUMFPACK_H
 
 #ifdef OCTAVE_MEX_FILE
-# ifdef HAVE_SUITESPARSE_UMFPACK_H
-#  include <suitesparse/umfpack.h>
-# endif
-# ifdef HAVE_UMFPACK_H
-#  include <umfpack.h>
-# endif
+# include <umfpack.h>
 #else
 
 /* Under MATLAB, we have to provide our own header file for functions in

class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-6.4.tar.xz"
  sha256 "9865e2e7f6b3705155538d5fb1fb0b01bc9decf07250b3b054d3555d651c3843"
  license "GPL-3.0-or-later"
  revision 2
  head "https://git.dynare.org/Dynare/dynare.git", branch: "master"

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "337cb317859a2d54947573d3ceb6b15b6074ce2a8bbbda18b997ca635321e47a"
    sha256 cellar: :any, arm64_sequoia: "cc083236da7a4665d0599355a603f8bbc51de92cfb79f8bb4c4c55a54d52fb1d"
    sha256 cellar: :any, arm64_sonoma:  "f8e8a2c036bc5c3dae19b0c928936c424499bccf8059f1eb58e247ec349ba2ab"
    sha256 cellar: :any, arm64_ventura: "948c9c2169b07c7f69ba0b46dd85f84e7a6c6765a8aab7a5aff4a3c14cde8b61"
    sha256 cellar: :any, sonoma:        "ef2157fe6556619e676f697ef14dc59cdd815d8da820eb64e8d5dbd8c7d9e997"
    sha256 cellar: :any, ventura:       "a46f9093f5999e6b35cb8049347e98285059c29c75db1ea19e22085f4a39eb67"
    sha256               x86_64_linux:  "98253a5506492a3afcf9adcad5d56e2a79d50531a422fd66cf7a9a5513e79266"
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "libmatio"
  depends_on "metis"
  depends_on "octave"
  depends_on "openblas"
  depends_on "suite-sparse"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
    depends_on "libomp"

    # Work around LLVM issue with structured bindings[^1] by partly reverting
    # commit[^2]. Upstream isn't interested in supporting Clang build[^3].
    #
    # [^1]: https://github.com/llvm/llvm-project/issues/33025
    # [^2]: https://git.dynare.org/Dynare/dynare/-/commit/6ff7d4c56c26a2b7546de633dbcfe2f163bf846d
    # [^3]: https://git.dynare.org/Dynare/dynare/-/issues/1977
    patch :DATA
  end

  fails_with :clang do
    build 1600
    cause "needs C++20 std::jthreads"
  end

  resource "slicot" do
    url "https://deb.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
    sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  end

  def install
    resource("slicot").stage do
      system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=../libslicot_pic.a",
             "FORTRAN=gfortran", "LOADER=gfortran"
      system "make", "clean"
      system "make", "lib", "OPTS=-fPIC -fdefault-integer-8",
             "FORTRAN=gfortran", "LOADER=gfortran",
             "SLICOTLIB=../libslicot64_pic.a"
      (buildpath/"slicot/lib").install "libslicot_pic.a", "libslicot64_pic.a"
    end

    # This needs a bit of extra help in finding the Octave libraries on Linux.
    octave = Formula["octave"]
    ENV.append "LDFLAGS", "-Wl,-rpath,#{octave.opt_lib}/octave/#{octave.version.major_minor_patch}" if OS.linux?

    # Help meson find `boost`, `suite-sparse` and `slicot`
    ENV["BOOST_ROOT"] = Formula["boost"].opt_prefix
    ENV.append_path "LIBRARY_PATH", buildpath/"slicot/lib"
    # NOTE: LIBRARY_PATH doesn't seem to work in Clang when `static` arg is used.
    # May be related to https://github.com/mesonbuild/meson/issues/10172
    inreplace "meson.build", "'umfpack', dirs : octlibdir / '../..',",
                             "'umfpack', dirs : '#{Formula["suite-sparse"].opt_lib}',"

    # Enable jthreads in Xcode 16.3-16.4: https://github.com/llvm/llvm-project/issues/104154
    ENV.append_to_cflags "-fexperimental-library" if OS.mac? && MacOS.version == :sequoia

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

    ENV.cxx
    ENV.append "CXXFLAGS", "-std=c++17" # octave >= 10 requires c++17
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
diff --git a/mex/sources/local_state_space_iterations/local_state_space_iteration_2.cc b/mex/sources/local_state_space_iterations/local_state_space_iteration_2.cc
index 5d0b0800b..97708e607 100644
--- a/mex/sources/local_state_space_iterations/local_state_space_iteration_2.cc
+++ b/mex/sources/local_state_space_iterations/local_state_space_iteration_2.cc
@@ -69,8 +69,10 @@ ss2Iteration_pruning(double* y2, double* y1, const double* yhat2, const double*
   const double one = 1.0;
   const blas_int ONE = 1;
 #endif
-  auto [ii1, ii2, ii3] = set_vector_of_indices(n, m); // vector indices for ghxx
-  auto [jj1, jj2, jj3] = set_vector_of_indices(q, m); // vector indices for ghuu
+  std::vector<int> ii1, ii2, ii3;// vector indices for ghxx
+  std::tie(ii1, ii2, ii3) = set_vector_of_indices(n, m);
+  std::vector<int> jj1, jj2, jj3;// vector indices for ghuu
+  std::tie(jj1, jj2, jj3) = set_vector_of_indices(q, m);
 #pragma omp parallel for num_threads(number_of_threads)
   for (int particle = 0; particle < s; particle++)
     {
@@ -148,8 +150,10 @@ ss2Iteration(double* y, const double* yhat, const double* epsilon, const double*
   const double one = 1.0;
   const blas_int ONE = 1;
 #endif
-  auto [ii1, ii2, ii3] = set_vector_of_indices(n, m); // vector indices for ghxx
-  auto [jj1, jj2, jj3] = set_vector_of_indices(q, m); // vector indices for ghuu
+  std::vector<int> ii1, ii2, ii3;// vector indices for ghxx
+  std::tie(ii1, ii2, ii3) = set_vector_of_indices(n, m);
+  std::vector<int> jj1, jj2, jj3;// vector indices for ghuu
+  std::tie(jj1, jj2, jj3) = set_vector_of_indices(q, m);
 #pragma omp parallel for num_threads(number_of_threads)
   for (int particle = 0; particle < s; particle++)
     {

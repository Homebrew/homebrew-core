class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/refs/tags/release/5.13.0.tar.gz"
  sha256 "1bfcd8a314706b3ac7831f215bae50251d9b61f3bbe90cbdcbed190741f6ee54"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(%r{^(?:release/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d56074a77028dcfdb9d9d59b2fcd57aad7e2df80c9f99df8f5c4286ef16c3b7f"
    sha256 cellar: :any,                 arm64_sequoia: "bf9b8dbe11fa244c8f7f6b052f12630a38040f9c02d17be2e075306eb98e2b02"
    sha256 cellar: :any,                 arm64_sonoma:  "cbd9e3001b700ea908fe9873fd9b059d634f437818ea3ccc2e38a6fa21195cb8"
    sha256 cellar: :any,                 sonoma:        "50c0d3151e24e96ec77ce11263d701b9c2e911dd4a9eb1fbfb9173cc85777500"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f973a7d348b3dc75f6bc4ef3c4d243617103a1e18e42be3c927ca075b8029de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a14f3873914b9f6631948386fe1a9ef164d7a5812597e508117aab2ea83f382c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "gmp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Currently using revision in flake.lock
  resource "cadical" do
    url "https://github.com/meelgroup/cadical/archive/8fcb8139c453e7cb85c470cea5d783db8e229518.tar.gz"
    sha256 "9880d09a7ff3d9dc4b633fa8230ff168b089c78a4c1811efd467925eb9972f9b"
  end

  # Currently using revision in flake.lock
  resource "cadiback" do
    url "https://github.com/meelgroup/cadiback.git",
        revision: "c24a73f62da2f984df6d3f1cf37283b1ca1c9f9e"
  end

  # Apply modified Arch Linux patch to avoid rebuilding C++ library for Python bindings
  patch :DATA

  # Apply Arch Linux patch to avoid paths to non-installed static libraries in CMake config file
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/cryptominisat/-/raw/f8e0e60b7d4fd9aa185a1a1a55dcd2b7ea123d58/link-private.patch"
    sha256 "a5006f49e8adf1474725d2a3e4205cdd65beb2f100f5538b2f89e14de0613e0f"
  end

  def python3
    "python3.14"
  end

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    (buildpath/name).install buildpath.children
    (buildpath/"cadical").install resource("cadical")
    (buildpath/"cadiback").install resource("cadiback")

    ENV.append_to_cflags "-fPIC" if OS.linux?

    cd "cadical" do
      system "./configure"
      system "make", "-C", "build", "libcadical.a"
    end

    cd "cadiback" do
      system "./configure"
      system "make", "libcadiback.a"
    end

    system "cmake", "-S", name, "-B", "build", "-DMIT=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(source: prefix/Language::Python.site_packages(python3))}"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./#{name}"
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cryptominisat5 simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.py").write <<~PYTHON
      import pycryptosat
      solver = pycryptosat.Solver()
      solver.add_clause([1])
      solver.add_clause([-2])
      solver.add_clause([-1, 2, 3])
      print(solver.solve()[1])
    PYTHON
    assert_equal "(None, True, False, True)\n", shell_output("#{python3} test.py")
  end
end

__END__
diff --git a/setup.py b/setup.py
index 537d78313..2e9a58ffd 100644
--- a/setup.py
+++ b/setup.py
@@ -58,51 +58,9 @@ def gen_modules(version):
         include_dirs = ["src/", "./"],
         sources = ["python/src/pycryptosat.cpp",
                    "python/src/GitSHA1.cpp",
-                   "src/backbone.cpp",
-                   "src/cardfinder.cpp",
-                   "src/ccnr_cms.cpp",
-                   "src/ccnr.cpp",
-                   "src/clauseallocator.cpp",
-                   "src/clausecleaner.cpp",
-                   "src/cnf.cpp",
-                   "src/completedetachreattacher.cpp",
-                   "src/cryptominisat_c.cpp",
-                   "src/cryptominisat.cpp",
-                   "src/datasync.cpp",
-                   "src/distillerbin.cpp",
-                   "src/distillerlitrem.cpp",
-                   "src/distillerlong.cpp",
-                   "src/distillerlongwithimpl.cpp",
-                   "src/gatefinder.cpp",
-                   "src/gaussian.cpp",
-                   "src/get_clause_query.cpp",
-                   "src/hyperengine.cpp",
-                   "src/idrup.cpp",
-                   "src/intree.cpp",
-                   "src/lucky.cpp",
-                   "src/matrixfinder.cpp",
-                   "src/occsimplifier.cpp",
-                   "src/packedrow.cpp",
-                   "src/propengine.cpp",
-                   "src/reducedb.cpp",
-                   "src/sccfinder.cpp",
-                   "src/searcher.cpp",
-                   "src/searchstats.cpp",
-                   "src/sls.cpp",
-                   "src/solutionextender.cpp",
-                   "src/solverconf.cpp",
-                   "src/solver.cpp",
-                   "src/str_impl_w_impl.cpp",
-                   "src/subsumeimplicit.cpp",
-                   "src/subsumestrengthen.cpp",
-                   "src/vardistgen.cpp",
-                   "src/varreplacer.cpp",
-                   "src/xorfinder.cpp",
-                   "src/oracle/oracle.cpp",
-                   "src/oracle_use.cpp",
-                   "src/probe.cpp",
                ],
-        libraries = ['/usr/lib/libcadiback.so'], #, 'libgmpxx.so', 'libgmp.so'
+        library_dirs = ["../build/lib"],
+        libraries = ['cryptominisat5', '/usr/lib/libcadiback.so'], #, 'libgmpxx.so', 'libgmp.so'
         extra_compile_args = extra_compile_args_val,
         define_macros=define_macros_val,
         language = "c++",

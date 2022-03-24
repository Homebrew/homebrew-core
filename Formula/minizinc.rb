class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.6.2.tar.gz"
  sha256 "0893bb0d37336fdc75c5f8864135e1abc571af422df9fbd41432776cedd3ebbc"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "43d87079948f0fafc359731844dc494b9d6727cb20a2d2d9bed8d0ed3d101cab"
    sha256 cellar: :any,                 arm64_big_sur:  "fe444844c4a9b585f70a82cb93106f956c6e69392ac8a70b8e3aa8f09f214891"
    sha256 cellar: :any,                 monterey:       "6a2b15c70e6e42f7a6e206971a91e6b9c7193aee0df57d9c0d01363f93e64b36"
    sha256 cellar: :any,                 big_sur:        "a51b5950cc114e1ebafe1a5ab7a5a8eb401e3023c4f7f8746f0adadf6e95f778"
    sha256 cellar: :any,                 catalina:       "ca44b073b683adb8dfc65072b158658ec82aca056b4a27ac3afd321e95b696a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4d491eb72caaced07731e10f3dea5deebbd68031596fa13755279377b3433b3"
  end

  depends_on "cmake" => :build
  depends_on "cbc"
  depends_on "gecode"

  on_linux do
    depends_on "gcc"
  end

  # Workaround for https://github.com/MiniZinc/libminizinc/issues/546 by undoing commit
  # 894d2d97b5d7c9a24a1b87d71f4c27f9e6a5f0e7, as suggested by a comment there.  Remove
  # this patch when upstream resolves that issue.
  fails_with gcc: "5"

  patch :DATA

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"satisfy.mzn").write <<~EOS
      array[1..2] of var bool: x;
      constraint x[1] xor x[2];
      solve satisfy;
    EOS
    assert_match "----------", shell_output("#{bin}/minizinc --solver gecode_presolver satisfy.mzn").strip

    (testpath/"optimise.mzn").write <<~EOS
      array[1..2] of var 1..3: x;
      constraint x[1] < x[2];
      solve maximize sum(x);
    EOS
    assert_match "==========", shell_output("#{bin}/minizinc --solver cbc optimise.mzn").strip
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index bfeb7ad4..c317f30d 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -33,7 +33,7 @@ if(POLICY CMP0074)
   cmake_policy(SET CMP0074 NEW)
 endif(POLICY CMP0074)
 find_package(Geas)
-find_package(Gecode 6.3 COMPONENTS Driver Float Int Kernel Minimodel Search Set Support)
+find_package(Gecode 6.2 COMPONENTS Driver Float Int Kernel Minimodel Search Set Support)
 find_package(OsiCBC)
 if(NOT CPLEX_PLUGIN)
 	find_package(CPlex REQUIRED)
diff --git a/include/minizinc/solvers/gecode_solverinstance.hh b/include/minizinc/solvers/gecode_solverinstance.hh
index 19328341..d020867d 100644
--- a/include/minizinc/solvers/gecode_solverinstance.hh
+++ b/include/minizinc/solvers/gecode_solverinstance.hh
@@ -192,7 +192,6 @@ public:
   int nodes = 0;
   int fails = 0;
   int time = 0;
-  int restarts = 0;
   int seed = 1;
   double decay = 0.5;
 };
diff --git a/solvers/gecode/gecode_solverinstance.cpp b/solvers/gecode/gecode_solverinstance.cpp
index f37dae02..8638fed4 100644
--- a/solvers/gecode/gecode_solverinstance.cpp
+++ b/solvers/gecode/gecode_solverinstance.cpp
@@ -109,14 +109,6 @@ bool GecodeSolverFactory::processOption(SolverInstanceBase::Options* opt, int& i
     if (a_d >= 0) {
       _opt.a_d = static_cast<unsigned int>(a_d);
     }
-  } else if (string(argv[i]) == "--restart-limit") {
-    if (++i == argv.size()) {
-      return false;
-    }
-    int restarts = atoi(argv[i].c_str());
-    if (restarts >= 0) {
-      _opt.fails = restarts;
-    }
   } else if (string(argv[i]) == "--fail") {
     if (++i == argv.size()) {
       return false;
@@ -164,8 +156,6 @@ void GecodeSolverFactory::printHelp(ostream& os) {
      << "    node cutoff (0 = none, solution mode)" << std::endl
      << "  --fail <f>" << std::endl
      << "    failure cutoff (0 = none, solution mode)" << std::endl
-     << "  --restart-limit <n>" << std::endl
-     << "    restart cutoff (0 = none, solution mode)" << std::endl
      << "  --time <ms>" << std::endl
      << "    time (in ms) cutoff (0 = none, solution mode)" << std::endl
      << "  -a, --all-solutions" << std::endl
@@ -1309,10 +1299,9 @@ void GecodeSolverInstance::prepareEngine() {
     int nodeStop = _opt.nodes;
     int failStop = _opt.fails;
     int timeStop = _opt.time;
-    int restartStop = _opt.restarts;
 
     engineOptions.stop =
-        Driver::CombinedStop::create(nodeStop, failStop, timeStop, restartStop, false);
+        Driver::CombinedStop::create(nodeStop, failStop, timeStop, false);
 
     // TODO: add presolving part
     if (currentSpace->solveType == MiniZinc::SolveI::SolveType::ST_SAT) {

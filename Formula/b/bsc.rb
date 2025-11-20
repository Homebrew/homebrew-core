class Bsc < Formula
  desc "Bluespec Compiler (BSC)"
  homepage "https://github.com/B-Lang-org/bsc"
  url "https://github.com/B-Lang-org/bsc.git",
      tag:      "2025.07",
      revision: "282e82e95da4b8cdedc3af3431a45cc1c630c291"
  license "BSD-3-Clause"
  head "https://github.com/B-Lang-org/bsc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "271fac6bcb893b9ac9ed0816572967482485674525370bac1aec27e5fafdcec8"
    sha256 cellar: :any,                 arm64_sequoia: "73ca733dc6506343d400fb4b3615473893bb7c14b840f4bc2a87dee1fea1b6dc"
    sha256 cellar: :any,                 arm64_sonoma:  "a76320a8ef7ff83fdcfee1f8ab422f1907f17e38849ce7b7adf5093941ddeef1"
    sha256 cellar: :any,                 sonoma:        "99bea46008c809f6f605a517da2c24faf78ae7ce0ebfa015758e7d6c1a5d7744"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71d9a63e7c159e1ac85cff67a5e90f1711785d74ebc9250f470f361dd728648c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43b681c317a2919923ab0fcd8aea8fb74d2e5237fc4fa55cd2adef18cd8710dd"
  end

  depends_on "autoconf" => :build
  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gperf" => :build
  depends_on "make" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "icarus-verilog"
  depends_on "tcl-tk"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi"
  uses_from_macos "perl"

  conflicts_with "libbsc", because: "both install `bsc` binaries"

  # Workaround to use brew `tcl-tk` until upstream adds support
  # https://github.com/B-Lang-org/bsc/issues/504#issuecomment-1286287406
  patch :DATA

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--lib",
                    "old-time",
                    "regex-compat",
                    "split",
                    "syb"

    store_dir = Utils.safe_popen_read("cabal", "path", "--store-dir").chomp
    ghc_version = Utils.safe_popen_read("ghc", "--numeric-version").chomp
    package_db = "#{store_dir}/ghc-#{ghc_version}-inplace/package.db"

    with_env(
      PREFIX:           libexec,
      GHCJOBS:          ENV.make_jobs.to_s,
      GHCRTSFLAGS:      "+RTS -M4G -A128m -RTS",
      GHC_PACKAGE_PATH: "#{package_db}:",
    ) do
      system "make", "install-src", "-j#{ENV.make_jobs}"
    end

    bin.write_exec_script libexec/"bin/bsc"
    bin.write_exec_script libexec/"bin/bluetcl"
    lib.install_symlink Dir[libexec/"lib/SAT"/shared_library("*")]
    lib.install_symlink libexec/"lib/Bluesim/libbskernel.a"
    lib.install_symlink libexec/"lib/Bluesim/libbsprim.a"
    include.install_symlink Dir[libexec/"lib/Bluesim/*.h"]
  end

  test do
    (testpath/"FibOne.bsv").write <<~BSV
      (* synthesize *)
      module mkFibOne();
        // register containing the current Fibonacci value
        Reg#(int) this_fib();              // interface instantiation
        mkReg#(0) this_fib_inst(this_fib); // module instantiation
        // register containing the next Fibonacci value
        Reg#(int) next_fib();
        mkReg#(1) next_fib_inst(next_fib);

        rule fib;  // predicate condition always true, so omitted
            this_fib <= next_fib;
            next_fib <= this_fib + next_fib;  // note that this uses stale this_fib
            $display("%0d", this_fib);
            if ( this_fib > 50 ) $finish(0) ;
        endrule: fib
      endmodule: mkFibOne
    BSV

    expected_output = <<~EOS
      0
      1
      1
      2
      3
      5
      8
      13
      21
      34
      55
    EOS

    # Checking Verilog generation
    system bin/"bsc", "-verilog",
                      "FibOne.bsv"

    # Checking Verilog simulation
    system bin/"bsc", "-vsim", "iverilog",
                      "-e", "mkFibOne",
                      "-o", "mkFibOne.vexe",
                      "mkFibOne.v"
    assert_equal expected_output, shell_output("./mkFibOne.vexe")

    # Checking Bluesim object generation
    system bin/"bsc", "-sim",
                      "FibOne.bsv"

    # Checking Bluesim simulation
    system bin/"bsc", "-sim",
                      "-e", "mkFibOne",
                      "-o", "mkFibOne.bexe",
                      "mkFibOne.ba"
    assert_equal expected_output, shell_output("./mkFibOne.bexe")
  end
end

__END__
--- a/platform.sh
+++ b/platform.sh
@@ -78,7 +78,7 @@ fi
 ## =========================
 ## Find the TCL shell command
 
-if [ ${OSTYPE} = "Darwin" ] ; then
+if [ ${OSTYPE} = "SKIP" ] ; then
     # Have Makefile avoid Homebrew's install of tcl on Mac
     TCLSH=/usr/bin/tclsh
 else
@@ -106,7 +106,7 @@ TCL_ALT_SUFFIX=$(echo ${TCL_SUFFIX} | sed 's/\.//')
 
 if [ "$1" = "tclinc" ] ; then
     # Avoid Homebrew's install of Tcl on Mac
-    if [ ${OSTYPE} = "Darwin" ] ; then
+    if [ ${OSTYPE} = "SKIP" ] ; then
 	# no flags needed
 	exit 0
     fi
@@ -146,7 +146,7 @@ fi
 
 if [ "$1" = "tcllibs" ] ; then
     # Avoid Homebrew's install of Tcl on Mac
-    if [ ${OSTYPE} = "Darwin" ] ; then
+    if [ ${OSTYPE} = "SKIP" ] ; then
 	echo -ltcl${TCL_SUFFIX}
 	exit 0
     fi

class Bsc < Formula
  desc "Bluespec Compiler (BSC)"
  homepage "https://github.com/B-Lang-org/bsc"
  license "BSD-3-Clause"
  head "https://github.com/B-Lang-org/bsc.git", branch: "main"

  stable do
    url "https://github.com/B-Lang-org/bsc.git",
        tag:      "2025.01.1",
        revision: "65e3a87a17f6b9cf38cbb7b6ad7a4473f025c098"

    # Backport support for TCL 9
    patch do
      url "https://github.com/B-Lang-org/bsc/commit/8dbe999224a5d7d644e11274e696ea3536026683.patch?full_index=1"
      sha256 "2a17f251216fbf874804ff7664ffd863767969f9b7a7cfe6858b322b1acc027e"
    end
    patch do
      url "https://github.com/B-Lang-org/bsc/commit/36da7029be8ae11e8889db9a312f514663e44b96.patch?full_index=1"
      sha256 "ba76094403b68d16c47ee4fae124dec4cb2664e4391dc37a06082bde1a23bf72"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7073b1c25d1eaa4e1a03a1bca4671e1d9d5ccdb815cb7271569beb25bbabc9d3"
    sha256 cellar: :any,                 arm64_sequoia: "028d70a33adfee0459fe3b1e86925ee54496b7e9f3ac58d9d4cc1eab1895724a"
    sha256 cellar: :any,                 arm64_sonoma:  "398571c528bbc22cf0712375da5568afe655c0822457947036f70f4bf6af7014"
    sha256 cellar: :any,                 sonoma:        "dea530b42317ecab706119b9a802a9b58d7b9765ec150c3627dc17dbcfcf7150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b7c2c627c3a0d89cb4b3718ef7c9dc90ba7b6ad127537773c2f70f172736c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "996a523fc7fd725f0630cd44eb71cc3a0e35b5e0cf71285372077a4c436f5998"
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

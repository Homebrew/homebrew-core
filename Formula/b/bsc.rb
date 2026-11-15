class Bsc < Formula
  desc "Bluespec Compiler (BSC)"
  homepage "https://github.com/B-Lang-org/bsc"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/B-Lang-org/bsc.git", branch: "main"

  stable do
    url "https://github.com/B-Lang-org/bsc/archive/refs/tags/2026.07.1.tar.gz"
    sha256 "819026c092715671b17003dd9bad4863498d89171bfbf0ad358905161cf80db2"

    resource "yices" do
      url "https://github.com/B-Lang-org/bsc/releases/download/2026.07.1/yices-src-for-bsc-2026.07.1.tar.gz", using: :nounzip
      sha256 "a5114c8f1e04a75a06598ac9763922f9186554b6f1326c1454b2e06deafd5575"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "323b3ea0ac72592a6c37f079d8ea0435c7c01a3077df20b2e92c41ef3e424205"
    sha256 cellar: :any, arm64_tahoe:       "b049841441cbce5e98752172f20f402eab30a1f5eba5f0f0492d8c7e13499492"
    sha256 cellar: :any, arm64_sequoia:     "7a1f6e535570500088d040698d2ed54ee6e37bf8cb56734a6d791cd07cef6c9b"
    sha256 cellar: :any, arm64_linux:       "c2a8d89692430dd6653c285220305d7bd43070bf793c19e94742806335984fba"
    sha256 cellar: :any, x86_64_linux:      "2728a37a36ec9642142af0522082ea9dccbb3f210f7948301ca33071aaa610fd"
  end

  depends_on "autoconf" => :build
  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "icarus-verilog"
  depends_on "tcl-tk"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "libbsc", because: "both install `bsc` binaries"

  # TODO: Remove the Tcl 9.1 workaround once upstream supports it.
  # https://github.com/B-Lang-org/bsc/issues/1130
  # Workaround to use brew `tcl-tk` until upstream adds support
  # https://github.com/B-Lang-org/bsc/issues/504#issuecomment-1286287406
  patch :DATA

  def install
    # Directly running tar to unpack subdirectories into buildpath
    resource("yices").stage { system "tar", "-xzf", Dir["*.tar.gz"].first, "-C", buildpath } if build.stable?

    store_dir = buildpath/"store"
    haskell_libs = %w[old-time regex-compat split syb strict-concurrency]
    system "cabal", "v2-update"
    system "cabal", "--store-dir=#{store_dir}", "v2-install", "--lib", *haskell_libs

    package_db = store_dir.glob("ghc-*/package.db").first

    with_env(
      PREFIX:           libexec,
      GHCJOBS:          ENV.make_jobs.to_s,
      GHCRTSFLAGS:      "+RTS -M4G -A128m -RTS",
      GHC_PACKAGE_PATH: "#{package_db}:",
    ) do
      system "make", "install-src", "-j#{ENV.make_jobs}", "LIBGMPA=-lgmp"
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
--- a/platform.mk
+++ b/platform.mk
@@ -77,10 +77,10 @@
 ifeq ($(TCL_VERSION),8.6)
 TCL_DEFS=
 else
-ifeq ($(TCL_VERSION),9.0)
+ifneq ($(filter 9.0 9.1,$(TCL_VERSION)),)
 TCL_DEFS=TCL9
 else
-$(error Unsupported Tcl version: $(TCL_VERSION)
+$(error Unsupported Tcl version: $(TCL_VERSION))
 endif
 endif
 endif

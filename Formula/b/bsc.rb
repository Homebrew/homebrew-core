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
    sha256 cellar: :any,                 arm64_tahoe:   "ba525929310367c18e193ffb95e0becc4d9ee009ab746286edf3815db231e5d0"
    sha256 cellar: :any,                 arm64_sequoia: "023b416fedba9f986345a7b06763995b843fedf2fc45d0428d0f6410fedb8b12"
    sha256 cellar: :any,                 arm64_sonoma:  "bb8dea8de8ae93ed8c76cbb488ea19645acc76e8aebc3560063024fa381c026a"
    sha256 cellar: :any,                 arm64_ventura: "5fa279ba7f86d9b0fff2ab75b8d8890b852764e67baeebbcd0125b8c7239825a"
    sha256 cellar: :any,                 sonoma:        "c8959d3244856dc6562bea2cd1f06ff782195bde78363b1a8dd104176ec6c5f9"
    sha256 cellar: :any,                 ventura:       "9b975bff3f3232bd26626bc308ccba6d24d433575c88c0b72af4a17059ce4d36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de1d37f49533298da63ccbbff21907afbc8952df0ef6ef5d5553a2b720939ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14fba2d067b4da9b16420abf741db79db7eb696f9ff25f629dd205af07409a93"
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

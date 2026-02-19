class Bsc < Formula
  desc "Bluespec Compiler (BSC)"
  homepage "https://github.com/B-Lang-org/bsc"
  license "BSD-3-Clause"
  head "https://github.com/B-Lang-org/bsc.git", branch: "main"

  stable do
    url "https://github.com/B-Lang-org/bsc/archive/refs/tags/2025.07.tar.gz"
    sha256 "5019721717ac27bf80a549ccdd0fadf57ac7fe08cfbd75b0de98569fa36780f7"

    resource "yices" do
      url "https://github.com/B-Lang-org/bsc/releases/download/2025.07/yices-src-for-bsc-2025.07.tar.gz", using: :nounzip
      sha256 "a7211d089be68303983cc644b70edaae8efab529ff63fd8670a4f20119888781"

      livecheck do
        formula :parent
      end
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5a8e4ab5547aa47dfd38ebce591d09be2608ae9cbad646f812840a806d68bcf4"
    sha256 cellar: :any,                 arm64_sequoia: "82b90b50a08f90e075c141679c91e704e8c3464cd5fd7c6086bd893db145a235"
    sha256 cellar: :any,                 arm64_sonoma:  "49f11cd1b6c4f92ee3a5c51b460c6095ce5f82b66af0ef81795d28859ca8ae8a"
    sha256 cellar: :any,                 sonoma:        "b0ba897244b18a97622c214ac93cfab649489e0e6ab1451e087a91a87ac10e32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "684b5a230253935597e9048fe6f61cc9a8d0b01e98b1acbc4fff3d06cefa14f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a798403601b1b39a0296b83b31d4db1ad055bc13d83a8b6c1cbafebaa08ab53b"
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

  # Workaround to use brew `tcl-tk` until upstream adds support
  # https://github.com/B-Lang-org/bsc/issues/504#issuecomment-1286287406
  patch :DATA

  def install
    # Directly running tar to unpack subdirectories into buildpath
    resource("yices").stage { system "tar", "-xzf", Dir["*.tar.gz"].first, "-C", buildpath } if build.stable?

    store_dir = buildpath/"store"
    haskell_libs = %w[old-time regex-compat split syb]
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

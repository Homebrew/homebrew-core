class Bsc < Formula
  desc "Bluespec Compiler (BSC)"
  homepage "https://github.com/B-Lang-org/bsc"
  license "BSD-3-Clause"
  head "https://github.com/B-Lang-org/bsc.git", branch: "main"

  stable do
    url "https://github.com/B-Lang-org/bsc/archive/refs/tags/2026.01.tar.gz"
    sha256 "f9204b7d6efd6ac2b2c1b42c80b01d179319ac33575d258719eaf73be44d4ec5"

    resource "yices" do
      url "https://github.com/B-Lang-org/bsc/releases/download/2026.01/yices-src-for-bsc-2026.01.tar.gz", using: :nounzip
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
    sha256 cellar: :any,                 arm64_tahoe:   "d8f0f4684c6942cb3f8bebaf6887a34b423f943dd14a7d732cf510d000f5aedf"
    sha256 cellar: :any,                 arm64_sequoia: "81122fad527aa5eb99d9f3eb6f020febfe0eecaacce237e6458b9fbf51c48113"
    sha256 cellar: :any,                 arm64_sonoma:  "6eccf669a11573271f60e49d71a88d9205024363ed20926bef42f97898de2ab4"
    sha256 cellar: :any,                 sonoma:        "b00f8030da0c9306aa05f303e1655a339e45b5a19b4265d9177609f928133e3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1162728cde2aaddca9401e47a219a328c4885090333fb436052983b706b9bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5c042102cb67bdd8b81b9ae4e065bd41e413ede786fc2f9986c655e2ef7bb18"
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

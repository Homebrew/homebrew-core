class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "49236096e7b99c569cdb9d8a0976a32dbdfa910028af29391d7f5666da67977b"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "28f75549b1838d14214ec81f75c90e694cad0b087634d5da52d3abe4bb56b381"
    sha256 cellar: :any,                 arm64_monterey: "c1ac3ee2372466e35501dd1471f9905518eb0137f65038b38ec915af8f2c89dc"
    sha256 cellar: :any,                 arm64_big_sur:  "c2b884ab6dc70487b7e663fbc44611b0fb5212740684ae123e14e858d1f4021e"
    sha256 cellar: :any,                 ventura:        "eafd1a179506c069bbf2a1a2e39bac218885f2f2d632075395b1cc8ba4d86180"
    sha256 cellar: :any,                 monterey:       "c1bf97c0dabb58da077a6a952208da6f5906f7c8a6855f1481ee080461f0de62"
    sha256 cellar: :any,                 big_sur:        "a43f323a93f21234bdd69b3c919e369a67e02cd9a462995a539d3b665aa2b55c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b671ae14db0385936f048b9be8f98aa7f2baabadf037bb3e15769667487df28"
  end

  depends_on "ghc@9.2" => :build
  depends_on "haskell-stack" => :build

  depends_on "truffle" => :test

  depends_on "crytic-compile"
  depends_on "libff"
  depends_on "secp256k1"
  depends_on "slither-analyzer"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    ghc_args = [
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
      "--extra-include-dirs=#{Formula["libff"].include}",
      "--extra-lib-dirs=#{Formula["libff"].lib}",
      "--extra-include-dirs=#{Formula["secp256k1"].include}",
      "--extra-lib-dirs=#{Formula["secp256k1"].lib}",
      "--flag=echidna:-static",
    ]

    system "stack", "-j#{jobs}", "build", *ghc_args
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install", *ghc_args
  end

  test do
    system "truffle", "init"

    (testpath/"contracts/test.sol").write <<~EOS
      pragma solidity ^0.8.0;
      contract True {
        function f() public returns (bool) {
          return(false);
        }
        function echidna_true() public returns (bool) {
          return(true);
        }
      }
    EOS

    assert_match(/echidna_true:(\s+)passed!/,
                 shell_output("#{bin}/echidna --format text #{testpath}"))
  end
end

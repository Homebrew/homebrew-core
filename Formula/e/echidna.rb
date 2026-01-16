class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  stable do
    url "https://github.com/crytic/echidna/archive/refs/tags/v2.3.0.tar.gz"
    sha256 "6fb673b10fc22068f74529ceff4e10b779f9489acaf189148fcb48f317606bf8"

    # GHC 9.10 fixes
    # https://github.com/crytic/echidna/pull/1500
    patch do
      url "https://github.com/crytic/echidna/commit/e302a0ab768d382644be4895d7a3aab60942952d.patch?full_index=1"
      sha256 "a0ed8330757f925f7832872ac33a9912f3dbdb52c63c363f090eacd5214ede34"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2959014c245f48091a17431a0f25f2add16f5e753a598c4f5668dc7a4b7b6663"
    sha256 cellar: :any,                 arm64_sequoia: "122afc3cbcdb997b2e490cc1959e32a8dda3ea7079dce4a87a40ee4c9a77016e"
    sha256 cellar: :any,                 arm64_sonoma:  "cd30326888e4cc7f00ba3becfa9a603fc68767bb2d1e5c262f926dc9bf862ec5"
    sha256 cellar: :any,                 sonoma:        "28f133e7ace9607803b0d93bcc10f0f158fe22d6b84c0bf538b582a7fb6e0589"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b14de6de490927ba6db29496b45e3d18213f6f8da65d992d61a089693c780403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40ff247be0dee656ee1a7b0bbfc561abf0c558ab87c89a1b314432ccb11b135a"
  end

  depends_on "ghc@9.10" => :build
  depends_on "haskell-stack" => :build
  depends_on "solidity" => :test

  depends_on "crytic-compile"
  depends_on "gmp"
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
    (testpath/"test.sol").write <<~SOLIDITY
      pragma solidity ^0.8.0;
      contract True {
        function f() public returns (bool) {
          return(false);
        }
        function echidna_true() public returns (bool) {
          return(true);
        }
      }
    SOLIDITY

    assert_match("echidna_true: passing",
                 shell_output("#{bin}/echidna --format text --contract True #{testpath}"))
  end
end

class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "4ba8598467d06c6f2ea6ca453b2c4e51c318752dff39cd1c8510470ed0fd7b75"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "95899ade7e9c31097b1c4f0121b4c007deb0190243f2eb7c4fc7707f635455f2"
    sha256 cellar: :any,                 arm64_sequoia: "7471d1fcb3862213037f7a66b84c1831c89c13926618209820a9acbc0c5b3887"
    sha256 cellar: :any,                 arm64_sonoma:  "f15ad76cbfded816b2bbeb2117639347260581e622591e532a802ebafc07ee68"
    sha256 cellar: :any,                 sonoma:        "395a3e87b997ae6ab4b770078e00c265badd2b87b70da9612ddf30df187d1752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad2f6057bd74851ec6f4567602593e200a6eab5eaeaeccccbaf1eee7c7274032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6a7540c87c2a4d60019cdc5b748d14fe26f7add7b75493c5d7a7fa2a2df12e3"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

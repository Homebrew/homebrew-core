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
    sha256 cellar: :any,                 arm64_tahoe:   "b4c0c8e4703789c0a9a78b8581dbd70d8111ce6df831232915a4df984e886de1"
    sha256 cellar: :any,                 arm64_sequoia: "b82dac91e964bcaccb7daf3bf674390548087480013e4b5a6e8988df4a7d7d91"
    sha256 cellar: :any,                 arm64_sonoma:  "a390cb7a1f470f2c745413f52686357d1a0e1a08d54090c7a4d2a9c70162951e"
    sha256 cellar: :any,                 sonoma:        "8dc501bded131ae6f2902e226834031ceb45780219771b102416af8017fe15c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7f057c41d4aa548b33bf692c57d697d16363bc3694511bd3117e5ccdbbdb47c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0799bd6976031fa133b66f5262a9327260cf4a3da4fc44452054c021d7260b7a"
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

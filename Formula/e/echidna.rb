class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "c35a6f65c8758743253e91d5ce25017d0d69864f3fad58c41269e9ef4089c1a1"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "73ee5125c1c57859fd03769004a15aef0a1a15269ca2347c7ad83d0ecf91ee01"
    sha256 cellar: :any,                 arm64_sequoia: "d03c58df980548b41ab1142cf07d1a1ef6ef65b35e687250634f3fd508aa9139"
    sha256 cellar: :any,                 arm64_sonoma:  "7894e8b14c9288b42e4517c82b4a7e55b3b6a90797bb863c155aeec4cd619820"
    sha256 cellar: :any,                 sonoma:        "a55c55db6a2ac10af2eb9b074e172aa8752307ce21b000ec7f98a8961e9313d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "772ac3f480f5cb1d4b6c075d856ae2954ca8f211487e438ef7e0a6b270ec251e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a13f6c68f9407099551800aed96a4ec194b7c931b57b1b2f083a4ad781e3f0dd"
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

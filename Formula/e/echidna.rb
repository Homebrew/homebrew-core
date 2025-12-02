class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "d1977efb56969daf3df4011e6acd694ad88fc639575f7fe2998c2c291e5c8236"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0824468f8ae3cede9d7b9c77848e0ee26f7b8b9501fd94088780ba0a0888b1a"
    sha256 cellar: :any,                 arm64_sequoia: "9f656148996de051b6c650ac8a4e0bda0776b7cd7bdb7a3dd7fe5c12ff9b7b1d"
    sha256 cellar: :any,                 arm64_sonoma:  "c8a49a687794a368c0d4a08c418e2d19731b9c9a34b4e8161be69aba4aa33631"
    sha256 cellar: :any,                 arm64_ventura: "95eb1e24a25981be6e48143cfc873f6d11f32578de0161b966adcf24ad0a681e"
    sha256 cellar: :any,                 sonoma:        "d819faadfba9489eead88647f7a67d6216506dc540d8f20ce615e0c484ecfea7"
    sha256 cellar: :any,                 ventura:       "4177319f1e989e91ead219bca0e42a3294392bcfdf2c53f566164d3089be5434"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "297f764859d6e4338ad34b64492cb4b674d59c585cf9e9561f62d55875cd59cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "450d22a5f95ff25c09bcf37ddbbc87516faafd7e09ef2ba2159bf3e37ace0bb2"
  end

  depends_on "ghc@9.8" => :build
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

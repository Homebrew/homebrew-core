class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "699e6f6369e7bd35f0324767c60005ae10ad7c71dc3ac682dd3a3294cd34a8e9"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6070db61524a6b0dbad453835890ef02ad5826ccae68b96771772a721eb60578"
    sha256 cellar: :any,                 arm64_sonoma:  "455439b7e0fe4bc487bb76bc859c048c1cf84c23f7ffc27587915da0f7c6fb0c"
    sha256 cellar: :any,                 arm64_ventura: "8f529c4e97f41611657d0fdfbbc2aa5b88c54af0fe578d176413caca679ea89f"
    sha256 cellar: :any,                 sonoma:        "169113958d861631bf7ab556fac14807670d4333edf491d12b53ee727ec32da2"
    sha256 cellar: :any,                 ventura:       "f70af17e76fc6c33f74499e9e5e8fa571c88476fb9497d78aac53d26b6a9fee8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2de0d84873ef2ad234ca0410bd72a217fad5f225aae6fb3df215c7db23f218f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22c09f288e1586ba70df669311ec7ecb02acdd378970fbfd731a76033eacd751"
  end

  depends_on "ghc@9.6" => :build # GHC 9.8 PR: https://github.com/crytic/echidna/pull/1334
  depends_on "haskell-stack" => :build

  depends_on "truffle" => :test

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
    system "truffle", "init"

    # echidna does not appear to work with 'shanghai' EVM targets yet, which became the
    # default in solc 0.8.20 / truffle 5.9.1
    # Use an explicit 'paris' EVM target meanwhile, which was the previous default
    inreplace "truffle-config.js", %r{//\s*evmVersion:.*$}, "evmVersion: 'paris'"

    (testpath/"contracts/test.sol").write <<~SOLIDITY
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

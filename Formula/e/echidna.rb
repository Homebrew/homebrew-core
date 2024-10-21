class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "148504b6881727265f4fd87c699cf521b0cb8bb7b0dea4cba42b97e2d588ec16"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c9e94bf4c97bafd0e1fc251dce2b29121ec3bbdbd520d48bd03a0de4ee3f435d"
    sha256 cellar: :any,                 arm64_sonoma:  "cf4de3a986d90a16181fb6e2894a8087d152444cc04a0d22537871a95e606044"
    sha256 cellar: :any,                 arm64_ventura: "3e9d815f85799ddab0c9be12f6cf5b401cb54f726d1175620ac6ffd1db036b6d"
    sha256 cellar: :any,                 sonoma:        "0c6aef5bb39540cbaa2c82b0bfea6a96776a2959a3325f463eb36f9de0dc1fe6"
    sha256 cellar: :any,                 ventura:       "5823671499b3db472bbca4c4d6e005577037e9d9f74f333e6fa27fa8fe8cd99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e7f76399aa45c6dca6bca5202ca791a6882b127f814ffffed81a2125e29911c"
  end

  depends_on "ghc@9.6" => :build
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

    assert_match("echidna_true: passing",
                 shell_output("#{bin}/echidna --format text --contract True #{testpath}"))
  end
end

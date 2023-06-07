class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "919a46d5820acdc26c119d2dc36b2abadb2383217a801ba07b1335aac1d07ee1"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ff308506a12501cf3467b215f107cf548cafe72e7aaa8f28c672b6511b6473b9"
    sha256 cellar: :any,                 arm64_monterey: "aba914ef3501bd026051ba3ea47873358d12ad730660367ae44da126c8cb552b"
    sha256 cellar: :any,                 arm64_big_sur:  "2a9709a8b22dd2b83374d50486da0d46d63b9c0f3726d7f10ea6911bee851ce9"
    sha256 cellar: :any,                 ventura:        "e17deb347c7cc690b7d22f47cec758c275f7bb3573e6c63b1e22f4b1ac18f21c"
    sha256 cellar: :any,                 monterey:       "8b74d214ea5b17fbae7183085323447a5d27364ed9e2183bab0b24a8244b9409"
    sha256 cellar: :any,                 big_sur:        "03295891e05bf372791aa18c915ab49920913fd2176c090d8519ef400ce9b6bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "069ba0435419a85b1105331b1e38458f25cc90b2b16c283c396699d6b7fa97b6"
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

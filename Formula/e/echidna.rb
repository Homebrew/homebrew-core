class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "5dd35a3f7e95bdc9f31be93f87cfa8e0e76f974fbe9d0bf4ce6c5829dce09c62"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3d08b9f25134ba9165eaee16c37bbbd2dfe80b06bf55eecb7db4820e6376a1a3"
    sha256 cellar: :any,                 arm64_ventura:  "db5c111bc49deb84dd2be5b60c24abeb7aeff991ceb7c723dad3120aa1d37776"
    sha256 cellar: :any,                 arm64_monterey: "aa493c077e188547d86213d4a2d90a88df649f6798f87491233d9e5db16ae436"
    sha256 cellar: :any,                 sonoma:         "ba1a80cd7fa0139d14a9fd1110d7f2445bc7caef411ad503591e2460e189a0e3"
    sha256 cellar: :any,                 ventura:        "9f5f898378f89f2592c16b7ca974a63d55c4d6913bb942c8b66d15932d54a39b"
    sha256 cellar: :any,                 monterey:       "2172df63a57d8fc0bd639da0d711912cc939afd4ff8222587f5375e0cbdc3860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "686eedecd01d69970633fd6fd023bb9fb7fce1791a60b876f5017394a74312e4"
  end

  depends_on "ghc@9.4" => :build
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

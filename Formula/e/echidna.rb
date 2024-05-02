class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "5d52aa22b360cc27155f195480a39d4e6cdfa8c88b39b8f25a64ef5799cb2f8e"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9976d9f5715ebc873d7056216fbdbcf8579c447c15998f02a89b4977f719923f"
    sha256 cellar: :any,                 arm64_ventura:  "04d426f750924952dd96d046f07b24845cc80d5cd83d6b0933480ce80ee7da0a"
    sha256 cellar: :any,                 arm64_monterey: "604023890a2aabe52303d2e20f49a9e2a1ab613ef817e371a14162115514aaa7"
    sha256 cellar: :any,                 sonoma:         "698790f4ba7684285027ce801333ed8e3c1f4e9adf03132aaffd147559737c1b"
    sha256 cellar: :any,                 ventura:        "56037ead666297d91874edf29a0d4907b61ee2e0e5731efb5dcae0b9550fa057"
    sha256 cellar: :any,                 monterey:       "b7a318183f1026ca3f07f0f32fd942d8dc18e55498ac31dd9137f561e24d9738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5aeac3e6360807349fb3ab4fc22926ee3035ada95a9e12c2e0e33870d11553e"
  end

  depends_on "ghc@9.4" => :build
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

class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://secure-contracts.com/program-analysis/echidna/index.html"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "c35a6f65c8758743253e91d5ce25017d0d69864f3fad58c41269e9ef4089c1a1"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "0939ffa6bff540a88601728d9c63f06f5f225011c3ff7df9c08f3b2fd11d6d9c"
    sha256 cellar: :any, arm64_sequoia: "a92d211d4856084650e988fbaabc3e186c730e8a5197d6559c019865cbe16b05"
    sha256 cellar: :any, arm64_sonoma:  "7f4ffd5c4e807333dd46c561ac8e2dc1bb91bcc4de8e3a8861f76fa84dd97cb2"
    sha256 cellar: :any, sonoma:        "603340c16e48cb87673eea4dfeb194f352a96653a315dce5e36f4eac9394550c"
    sha256 cellar: :any, arm64_linux:   "1555c7ad100819bac05dadc1ec63b6dee539a8b23c5aa3da7857aec471cf5c92"
    sha256 cellar: :any, x86_64_linux:  "ca111981088cd3b985778a9992cef6eec51d28a8987d2769ec4d75aa44868cc7"
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
      "--extra-include-dirs=#{Formula["libff"].include}",
      "--extra-lib-dirs=#{Formula["libff"].lib}",
      "--extra-include-dirs=#{Formula["secp256k1"].include}",
      "--extra-lib-dirs=#{Formula["secp256k1"].lib}",
      "--flag=echidna:-static",
      "--no-install-ghc",
      "--skip-ghc-check",
      "--system-ghc",
    ]
    ghc_args << "--ghc-options=-pie" if OS.linux? && Hardware::CPU.arm?

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

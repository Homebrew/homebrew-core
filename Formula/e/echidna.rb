class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "84387b95a9701fba409a11298a0cdc5cfba3925d4b606a70d1a53d1712a157dc"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1c712aa692b4ec1acaf4c4fff317b9e4adc7d6e747b78cc9e71752e326dc28cc"
    sha256 cellar: :any,                 arm64_ventura:  "6f9f753a62e73772c338ebd03ee27824fb86faee9947f8c4322b62e23a93b60a"
    sha256 cellar: :any,                 arm64_monterey: "e5cdf056186f5049ca602f7db6724bf174b238be52fd997d97a4efac72b3f422"
    sha256 cellar: :any,                 sonoma:         "abd2f7598cb49e5d895b75f477b39cd474494a910f15156a7791750acbbd8c15"
    sha256 cellar: :any,                 ventura:        "0372b29ebfe82d9e18acee15165179dd094f89b967baf36d813055be053fdc40"
    sha256 cellar: :any,                 monterey:       "4856a67d27440b55de6a8cfd32f5d9194c045b9877ad44751cff877aca617bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de518bd5a33ea60d6c7ad0995e8569e1cbc3ce22b5fbf02c3868ae791af9943b"
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

class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "cd98ba4c42df459e9ea438deac0d157cbc0edead9cc76dad3c9424f470c5a5b5"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b730a7f3b5ddb5cea45f1b2a9a146fa7985cebf42dbf23bb9cb9659c2d83c326"
    sha256 cellar: :any,                 arm64_ventura:  "295efec9e6e2124567a266e3ec8a69f4518daf87f9adc65735357e65c49eb4bd"
    sha256 cellar: :any,                 arm64_monterey: "5c30bf46addf6649edb963472f81282136ff6e28ef5f00530981ee442b1ec75f"
    sha256 cellar: :any,                 arm64_big_sur:  "d04f6539ef0896e5def97ccf243ef27b19ba8ca9dd13afaf5125e4d41028c0c4"
    sha256 cellar: :any,                 sonoma:         "bba9f3407bbb4abae221054b4f55c4421acd0dc3e337992ca137620ad32cedee"
    sha256 cellar: :any,                 ventura:        "71413a88143d3adb927c7722ae98648147cbbe10b8d3e753809ebe5e2bc016a2"
    sha256 cellar: :any,                 monterey:       "9abe5b39bdb786c7f43f7efe559f20fa1b8e8481e5856e272c86acb986d9e8ac"
    sha256 cellar: :any,                 big_sur:        "ae3d0c14f7428debcc424025731798aae09e06cf790124a9f39e2a3679b3a620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21d7cb1f1f1d0db89252b33cfa19963af73448f77048d0f0323265236ed078a6"
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

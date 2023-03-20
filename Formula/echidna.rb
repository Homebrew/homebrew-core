class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "c8e71f2b5900f019c8c4b81bb19626b486584fe63d2f9cdfad6ddd2a664a1d4c"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dcf170112210f244abb4dc4e07a75a09b59409ae71d5fe7250c07e3d12d5f029"
    sha256 cellar: :any,                 arm64_big_sur:  "ae9ac5a51425f596df283f53aa33fd4031ed5dcb22515c870ca3a3665c1e1d1f"
    sha256 cellar: :any,                 ventura:        "db742b78045169900941a6d043afe932a823fe037bf0f5ffb76be023f1095e63"
    sha256 cellar: :any,                 monterey:       "65a6b9f6498f796b56e83c1c2e43ea44948a8d4649cf2d596dea61ebaae2af78"
    sha256 cellar: :any,                 big_sur:        "244b94288758683a58c0114074e384ba813c4e30d7635ef9bcb0ebc163a6a45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e99cc1a243c861749b77d044ff8623b4cc7f168fde8c8fda85c82abfe3bdbe3"
  end

  depends_on "ghc@9.2" => :build
  depends_on "haskell-stack" => :build

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
    system "solc-select", "install", "0.7.0"

    (testpath/"test.sol").write <<~EOS
      contract True {
        function f() public returns (bool) {
          return(false);
        }
        function echidna_true() public returns (bool) {
          return(true);
        }
      }
    EOS

    with_env(SOLC_VERSION: "0.7.0") do
      assert_match(/echidna_true:(\s+)passed!/,
                   shell_output("#{bin}/echidna --format text #{testpath}/test.sol"))
    end
  end
end

class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://secure-contracts.com/program-analysis/echidna/index.html"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "9d0e9340d8164704beb2472b02b25ff3cab1b9538d885f936d3199532a6d219c"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "625a1a2f9106a562dfa2b5cefaab18c9e3e220b223ff182cc8e932003cc4600e"
    sha256 cellar: :any, arm64_tahoe:       "732961d8a2cd5705e2892030d504289fee67c3d297af1dd3f3b5b70f53a50b13"
    sha256 cellar: :any, arm64_sequoia:     "8b03d9b5d50e7ead10c311bdd02823d10163d5ec61e214591f1a5a8bc9eb945f"
    sha256 cellar: :any, arm64_linux:       "27ea65274433800d016b41973809f4a126f07559eff7caac6a266e7afa32a3e6"
    sha256 cellar: :any, x86_64_linux:      "2a6849010b0b1fc28fad827f04580399256b13ae254577b4ee98b7a71d71e674"
  end

  depends_on "ghc@9.10" => :build
  depends_on "haskell-stack" => :build
  depends_on "pkgconf" => :build
  depends_on "solidity" => :test

  depends_on "crytic-compile"
  depends_on "gmp"
  depends_on "libff"
  depends_on "libyaml"
  depends_on "secp256k1"
  depends_on "slither-analyzer"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.cxx11

    args = %W[
      --extra-include-dirs=#{formula_opt_include("libff")}
      --extra-include-dirs=#{formula_opt_include("secp256k1")}
      --extra-lib-dirs=#{formula_opt_lib("libff")}
      --extra-lib-dirs=#{formula_opt_lib("secp256k1")}
      --flag=echidna:-static
      --flag=libyaml:system-libyaml
      --jobs=#{ENV.make_jobs}
      --local-bin-path=#{bin}
      --no-install-ghc
      --skip-ghc-check
      --system-ghc
    ]
    if OS.linux?
      args << "--ghc-options=-pie"

      # Using global configuration to apply options to all dependencies
      Pathname("#{Dir.home}/.stack/config.yaml").write <<~YAML
        ghc-options:
          "$everything": -split-sections -fPIC -fexternal-dynamic-refs
      YAML
    end

    # Old version doesn't support base >=4.20 which comes with GHC 9.10+
    inreplace "stack.yaml", "allow-newer-deps:", "allow-newer-deps:\n- aeson-optics"

    # Let `stack` handle its own parallelization
    ENV.deparallelize { system "stack", "install", *args }
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

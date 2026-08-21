class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://secure-contracts.com/program-analysis/echidna/index.html"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "fab7817640a613856365766031518a8bde5471a9fb14618dfb0b77e3820a7cba"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "301cc7a8227ea14f11273e2ee9824a06f0a64881267c2ddc528c10429a1cf786"
    sha256 cellar: :any, arm64_sequoia: "a108b24ec074234e2f97e2638ad918fcad080823f0ee60bc0b47377d5db11881"
    sha256 cellar: :any, arm64_sonoma:  "d94158bc2ea76c2be300f055ba507dcbc378a06ff9222042d51b63781c849f75"
    sha256 cellar: :any, sonoma:        "c218fbc7ec6693122117803febd2c42855ef3d576bd96669e7c354832616dc7e"
    sha256 cellar: :any, arm64_linux:   "398632a21131bd0463663a246da6360940a94c29899987c22102bf0788039d7c"
    sha256 cellar: :any, x86_64_linux:  "a0071a9a2d39c8aee9ae64feda8fe8d3ae700da51e220c2258eb15f78f3975f5"
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
      --extra-include-dirs=#{Formula["libff"].include}
      --extra-include-dirs=#{Formula["secp256k1"].include}
      --extra-lib-dirs=#{Formula["libff"].lib}
      --extra-lib-dirs=#{Formula["secp256k1"].lib}
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

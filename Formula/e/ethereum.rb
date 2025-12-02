class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.16.7.tar.gz"
  sha256 "e0fded2ce7def3dc8c7e4e2f14086e14175775ec76d2f440ff6003b6dcaed939"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6656fdc6f2325460a1a0c3ce5d1eb987321c06e08a198aca48c34c2d8312558c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f05aca21332289c5b01f37975a9be523b9a1bf14cb1b5f95aa380cea38886967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d489163f6ae2fe66ab998ab67c218e8a8ee6f20a1a6e31f0134a94af42b18d7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe8435bee8f660b6c844db6f2c5b1fac3ebd68a5670b20b047d9e26d81f5fc42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71390b52c7d4fa3121b4023c6cc81020f3209b94bafba38f056dafba7b34cf37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45c9efe5d0eb58d03f9a83bd88c4bfbf998b3265c27627348548831948bf422f"
  end

  depends_on "go" => :build

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https://github.com/Homebrew/brew/issues/14763.
    ENV.O0 if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/ethereum/go-ethereum/internal/build/env.GitCommitFlag=#{tap.user}
      -X github.com/ethereum/go-ethereum/internal/build/env.GitTagFlag=v#{version}
      -X github.com/ethereum/go-ethereum/internal/build/env.BuildnumFlag=#{tap.user}
    ]
    (buildpath/"cmd").each_child(false) do |cmd|
      next if %w[keeper utils].include? cmd.basename.to_s

      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"
    end
  end

  test do
    (testpath/"genesis.json").write <<~JSON
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    JSON

    system bin/"geth", "--datadir", "testchain", "init", "genesis.json"
    assert_path_exists testpath/"testchain/geth/chaindata/000002.log"
    assert_path_exists testpath/"testchain/geth/nodekey"
    assert_path_exists testpath/"testchain/geth/LOCK"
  end
end

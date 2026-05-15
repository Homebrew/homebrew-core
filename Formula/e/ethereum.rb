class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "fe1fb68c8d3230570fcd20950d29c93768bd4a240070fee84274ce92a759d9a9"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a5e4fe02eafa736d249ae6193434b37c3838ab3b3a6859a0e6059f52ae20a08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eb69cb38ac24c3b9bea10766d76ee5f4ffb52c15dae54689ca6840c4905e3a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f176bc9cdb621107a4d5813e13508734a7a086e90b6e98db7b57e00114f30764"
    sha256 cellar: :any_skip_relocation, sonoma:        "755b46985258180475e89dca654190f668a874800f4b23570747bb8e80998183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "930674a02afa27bb80425563b977691a67cb8ccd9b1da4903def8aa4943e1e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a65faddf283b16b63b296d67843222044ab03c1ed1d06c04a256b998e87051f9"
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

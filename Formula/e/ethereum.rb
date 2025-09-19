class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "b8b5f5e373f072a6203d9bcadf1f8bce2cbab3d948e056314838642b7c3e9b81"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd087f751d24ca88bfae835f668ec39471f6b7b4cef0dce090817bc7544e4f94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf597a0cbf26b39d8a12755754649bcab8b372ad647e604ab98ecbd38711b240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61aeaa10a46f640656b89d2ecd709240292186a7d6861c188dc2b4fccdcd325f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c310dddcdaa02dbab4a3315cb10fba174e3abf284e6b6fa0492c77a2b2c1f9b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d3c5d26b47204a45db9e71890cb417fb8f05a97e87fb5f554c667b572d4577c"
    sha256 cellar: :any_skip_relocation, ventura:       "19522c93d7b2519b490b8c7a8aaabbbd62b29c9f1efbcfdaf8cfe06e86a26c24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fafa9aa1c29bd1bdb4f4dcc750ebd3893c9d306cca8c5decbae60b62b176f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c962d474a442519ca950204e03678956d0923d632fcca6bd27b867e98feefa1c"
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
      next if cmd.basename.to_s == "utils"

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

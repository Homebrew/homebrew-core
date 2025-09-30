class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.16.4.tar.gz"
  sha256 "f4cbfa29765b520e87d2e46452cdc04d418c143a703e51c05e5b852b33844bbc"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf13355e34db16f52c65f147351ae5107d6afd0c9b884e2fb94c90bb9700e7b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec04b2033842665db6831f5fb656ec62919b10643229a645c53111d330db78c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "924b78a2712c762faf44b7f1e940735f58cafbe16569a26c6c4a49fba5068712"
    sha256 cellar: :any_skip_relocation, sonoma:        "c21ede5742b3387822c435a0a8872cb148e5e8b7eca998d9b2fef8f3fc2ad926"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b54449f2ff5573eba97aeac7a382ebd5a0c04c131f767b91beba3d314e4fead0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36ac08f87f81b33e7d30116ac9d6ac45f56f0803618bbed1c76327e68d2183d2"
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

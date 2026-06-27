class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "80b4dee3b89ea40bedc808132befd605208089fdb8fde7981fc3c530596d3a9e"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7df73a921714d07b32c9b5c0a9154a97378c25f0e0fb0216fa701372698b56b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebe31cd02148d4c2e7f47bd603eced260a2b693f2d7a40981a0bf9400a36fde9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4df7078f565183ad418d22510f5c684e524994918bfe84d5fa2d6863151a720a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a13746e397fd46ee119d8bec55e4807628617d859be72b8b8bccc02d3f8d5665"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92776cb4383b5dbbf7f17d9fb2bf00372cc20937511a4431dfadeabc8d5e5acb"
    sha256 cellar: :any,                 x86_64_linux:  "7675a1b29d887c5a51efcc313d4454eed4d3b62cb838fd8f95f82d55c845be4c"
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

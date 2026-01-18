class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.16.8.tar.gz"
  sha256 "c9797ad1557b725b1b71e7ae12c1a1789bbdd691cf4abfcdb3f188356091aebe"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af368d6d627f3215996c76973bac55b6ccb6a471a40f078a054a900490993e8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c3f9208e707c15ef02a1aaffe6b1bcb7c4dea001984709cf21310d48ebe1e51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2efc7788aa7c81410f7e118d46eb9fae3a5690a0742815d0c9003a6f0c84139"
    sha256 cellar: :any_skip_relocation, sonoma:        "a856a980dd7560aa49df95595a58917a4ecdf92335298c78076661d3905a4634"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "455f8314380fa79341b0c27ecccb45255277f19514bb49b4435e0050d8c26af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7713aa74575c1413d171a9df3db4794444d74351beac97d62324a48bbdc0dc59"
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

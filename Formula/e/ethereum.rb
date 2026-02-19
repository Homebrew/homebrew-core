class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "a78d478d67f796c3fa73ebdc4a4da8093ab1c37486615e29b64cb9b0ae22e01a"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17178ca1184f97b92d71e96f6695f78a1921859611bf57cbde38f5a20d496962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a9407579479ada523d2f452d0bf7f3112dfb49c12ba290b5eae03c7a66cd16b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abb5440d0d02b6569c74f94f73dfdb4ca8b963777a572205f3bb671dabcb26a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebfe2b991888b38e4f7167ac338f2a09c7155db2972bc4749191d1ad48280f70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bbd60decd6c6bcabfe11d2a6a9e861e3a255fb1af0653cf092ddf01a00f36bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6631bccf15435431ff5d1c62b8212c0107d35ef3dec3fcbbfa9542823928122"
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

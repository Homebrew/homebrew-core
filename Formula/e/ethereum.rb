class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "cdbfcf0eb282849d0ffce21e1cffd82b51a1d08c27421d7fa86dccf65b76b523"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35462d8b06f3324d53fa07164fe5d392040a132a677ef8adcd6ddfb778ffb14f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9e983e699554ec0f9bdd278f2af225fbb5c418f51ef50c7c1bf01a259f4687b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fe2e43fdd8b540391045d8ddc11fb7ff489b31f91ceaf4572176780d07adf39"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6641e6c3ac2306b5111105115ebde62a97f6c9b04403feb2e559596fa455a7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2386fd1a732f38dc432f3dc906287b2dca33184a26f690a0cda3b411c148c6eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a2704d0a56ee295a403cfcda557c75e2ebe8e4a2e738a2e19538b6fb62597da"
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

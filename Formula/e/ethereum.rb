class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.17.5.tar.gz"
  sha256 "8428049b30e76efcd19507225aa67c67d5d98c10a0f3a4ea339dfbba285bac7d"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12d2b11da1c0b6619e13d3cc86ad83459410b85a9eb48b5d0a27028fc48c4cb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec5e60a5b948adf930f7cf08b0bef630e979a86cb842a519ae1a0a4fa30037dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fb56f12ee1745b9ee0863cdc5c95e0d78968bd6c0c75f39f63defb1f8400725"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9f745105329c47aa874d0dbc5af508a89887029489093e824e2557ad183e117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c85fe88f7e63c5c9737ee9d6b06748531a9ed94b0782cfdd42d060a81ba37a3"
    sha256 cellar: :any,                 x86_64_linux:  "99e3debd89b376ab8edeca2ec575fa210f0fb4a07bcbec51ba109a2c5fa40934"
  end

  # TODO: unpin go@1.26 when ethereum supports go 1.27
  depends_on "go@1.26" => :build

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https://github.com/Homebrew/brew/issues/14763.
    ENV.O0 if OS.linux?

    ldflags = %W[
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

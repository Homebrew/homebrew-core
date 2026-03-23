class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "82e31613391dd1eea7cfc5796c8cde89ad4958e0eff2402a08c12d6a3d7d091c"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83ff875f5e586fe78666b426b2221092cc4fb0efd8044de0a03d8e92cffc1a86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55adaafe381c555efd1fab808536b5d90e4a74021b4477dd2ca604725bbb9592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c7728999138e155c8185860f56488a49e095f383983aad86844397dfb543a14"
    sha256 cellar: :any_skip_relocation, sonoma:        "01affc8922be8d4c555c8b3a2d56f04e727cf955a69fe8dc8a81c19b3ca9bcd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "742997e1815d20c6b81c97490376742e31605368bc585570db5e3f2571e795d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9872ae15730473ef3eca0cdb2119ce56fa0fd5386070f767f847929f6235e4d6"
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

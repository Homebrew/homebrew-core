class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.53.4.tar.gz"
  sha256 "75832c951ae14958a000c8c066e5274012c4ca96dc3dd30e79147172017e1e28"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "645e59a7c94cea90db0102889c252b42c25f75592b1da0dc11762ce4b0e413fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6c5d381186b7a19cd5298e6b861fedd6e730ed56f86898626e05eabd6b6f667"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "051773ab3e1508fd05331d2abaed3b501ace5fa71f4f8fabd462d93a01daf559"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c7ba69732cc76033bea5bf6c5fc215fc075ce6780588dc1e9c78492b037d30a"
    sha256 cellar: :any_skip_relocation, ventura:        "940a94cff06cf7379863cf94ec89db08d6c7cdee33399027b8a1a910dd58e943"
    sha256 cellar: :any_skip_relocation, monterey:       "03f25ec5bc5a268698da1b244eb4e7b74966a46bdc254fddd6451df170cc1afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c5a3eed1f7a21bfd24e7be2e3c57ab60a967be1e9c83957430550e8bc4de274"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build

  conflicts_with "ethereum", because: "both install `evm` binaries"

  def install
    unless build.head?
      ENV["GIT_COMMIT"] = "unknown"
      ENV["GIT_BRANCH"] = "release"
      ENV["GIT_TAG"] = "v#{version}"
    end

    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~EOS
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
    EOS
    args = %W[
      --datadir testchain
      --log.dir.verbosity debug
      --log.dir.path #{testpath}
    ]
    system "#{bin}/erigon", *args, "init", "genesis.json"
    assert_predicate testpath/"erigon.log", :exist?
  end
end

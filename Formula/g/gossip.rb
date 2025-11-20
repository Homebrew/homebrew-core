class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https://github.com/mikedilger/gossip"
  url "https://github.com/mikedilger/gossip.git",
      tag:      "v0.14.0",
      revision: "53ba02c672e1f2e14da1df11a0fc43fcf19d2526"
  license "MIT"
  head "https://github.com/mikedilger/gossip.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92aa10431368840267d013fff2476487a70badc319682d5bd649cf00681917d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69f4c2c908a9e8fc06bc60fc13cf8a99cdc2e53c250e55135061746f1e6f1ac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52c0547db044f74634ca84ebf9ced852f23a91950d8d50fbc00faf3b5f04daba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0659e6181bcb7a871769af31433121f5a10e0a600b1ba37bcde69aba85c894d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bc84869c2e363b24b75f51e8bd0953c8b065dfadc6be87d942f4f2003ee6065"
    sha256 cellar: :any_skip_relocation, ventura:       "5e2f6d09d8d9907e6073d4a57420df775c38c856ea80576fb5beb799b874d4a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aee8f60a43435d9dea1b85a1335d45ccb0d6667d9b0480e4342afe5ce89b9aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb28f95a965f5ef4ffc6be6870a87dbc90d7ed00a9bd511df04ab45bf9f56dd"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libxkbcommon"
    depends_on "mesa"
  end

  def install
    ENV.append_to_rustflags "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args(path: "gossip-bin"), "--features", "lang-cjk"
  end

  test do
    mkdir_p testpath/"Library/Application Support" # for macos
    mkdir_p testpath/".local/share" # for linux
    json = <<~JSON
      {
        "id": "b9fead6eef87d8400cbc1a5621600b360438affb9760a6a043cc0bddea21dab6",
        "kind": 1,
        "pubkey": "82341f882b6eabcd2ba7f1ef90aad961cf074af15b9ef44a09f9d2a8fbfbe6a2",
        "created_at": 1676161639,
        "content": "this is going to work",
        "tags": [],
        "sig": "76d19889a803236165a290fa8f3cf5365af8977ee1e002afcfd37063d1355fc755d0293d27ba0ec1c2468acfaf95b7e950e57df275bb32d7a4a3136f8862d2b7"
      }
    JSON
    assert_match "Valid event", shell_output("#{bin}/gossip verify_json '#{json}'")
  end
end

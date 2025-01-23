class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https://github.com/mikedilger/gossip"
  url "https://github.com/mikedilger/gossip.git",
      tag:      "v0.13",
      revision: "90712385f6f79b60c01ae588464be4c960e76836"
  license "MIT"
  head "https://github.com/mikedilger/gossip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fdfbb83cdbeac9861dc02492374789e71f5e81a0051384e0cc9127196904887"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ccc7bfdabed68903460f725ec7ee4faca3da5abf4a33ee84a40419989e8e6e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9823af97210635cbca983bbc1499803609b49e1f4f237c671606662d78b65d5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8387d914d747f3e706b036cd6c909770e3929830c33997afd40edf7e410f01ff"
    sha256 cellar: :any_skip_relocation, ventura:       "93bfdc6916c089ee492aeb1b41eff174d5d298d91e815040f53389d9bbac5249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "266e409cb760cb7b52aa23c7bc98bde2e35cacb1fe8903d1fed42ff42facd758"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libxkbcommon"
    depends_on "mesa"
  end

  def install
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable"
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

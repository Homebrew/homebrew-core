class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https://github.com/mikedilger/gossip"
  url "https://github.com/mikedilger/gossip.git",
      tag:      "v0.12.0",
      revision: "cddb57cac6ca983e8d6aaa1636d4b466baefa811"
  license "MIT"
  head "https://github.com/mikedilger/gossip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8290c0cd8e7d1881d6e9beb2cbcff288684f11930207857da69b614507d1eeab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7834d369df37c14e3a7af29d6c18288c1e4ddaf0e5b867c94d80ac22f965ce4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1ea21ca38ec0b44ce03a87ff4d4be0e8148bbc64f9a7efc2a2a998ca59000dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "61ad70cf5c127ff720a26192c30d69d6070f9480b5ef6d720d95b60b07fca3f1"
    sha256 cellar: :any_skip_relocation, ventura:       "c433b47fec2c914d0bb16309b25756b43c9bd11e79d86cbfff3349988e65ab80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a1cc186edaa3971fd03ea1109cac44e9936125af49499da70093320073c38fb"
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

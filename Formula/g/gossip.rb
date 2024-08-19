class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https://github.com/mikedilger/gossip"
  url "https://github.com/mikedilger/gossip.git",
      tag:      "v0.11.3",
      revision: "bb3fcce0c24f6428af4a21933532de47f96cb67b"
  license "MIT"
  head "https://github.com/mikedilger/gossip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc29c7765fa723eadcb74f60509867e3e5a05b6455c71414249cbe24e8b7dd5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aeb8a0ca97c14556c4590c08dfd070eddb225701299ab39b9f884ba55deabc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "182c89ce8255708deaeb22fd60a18fe2900ca2654db84d2e0ad54b06f8a9d8eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "9396294ce567b4b95d2ab4561d7ffe05a110751f923b19142121a0db022b5d45"
    sha256 cellar: :any_skip_relocation, ventura:        "0a742ad18b38177f26698e85ba5daac6a8e94f9b700f3b76b6d7e208962d45d7"
    sha256 cellar: :any_skip_relocation, monterey:       "5d067f6f7ca49fe0a34f51f4b856aa73280c75c8b7fb12c41b7b599002b77294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87038f2b4384658839fcad457946ed2f0cecf7943ca8cf4488e2ec1c3eb6f0d1"
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

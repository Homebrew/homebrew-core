class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https://github.com/mikedilger/gossip"
  url "https://github.com/mikedilger/gossip.git",
      tag:      "v0.14.0",
      revision: "53ba02c672e1f2e14da1df11a0fc43fcf19d2526"
  license "MIT"
  head "https://github.com/mikedilger/gossip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "094397fd6b7fc10ccb5abfa09aacb87bc1bf9785e5931428e1147bbac8053a5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22707c47f4bc31392a931bf3b3eff6edd2e56dba3a038c4dbbce58e85db35843"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e16ee0487520298ce54b97437576af2fea08c177c436126734109125f74b00a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bba898419ef93f501fef1bc643215d94f7b0fc2d335798cdb14ac222f300698d"
    sha256 cellar: :any_skip_relocation, ventura:       "3b547d284bcaf51552faa323dc36f67a1b0e70a7ba8fe925f557794adb67f233"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf6f593ed8a27f441c52b38ad115ed7dd7e683c249dedad561f727ec871d2bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96696a0e96b1d6726003ed559c0a659df7925d310dcd3af9fc2623f5b48b3ba2"
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

class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https://github.com/mikedilger/gossip"
  url "https://github.com/mikedilger/gossip.git",
      tag:      "v0.8.1",
      revision: "404f5a405c8796e90bb5cc078378149d3c341f26"
  license "MIT"
  head "https://github.com/mikedilger/gossip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2574d71aa492b51c619097ef875c91ddb9b435c5d20a88e19bbbc5f1f4d26ef5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cf9ff27bc96868f2b49668d7b40c66dfb6555bc019c9b3c8b9c6fd97893e625"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fab2f3352410bbe227be6fb894a17cb1b76668bedc93b0ae953987ac09cc19f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "594738f0fe3a8da03db3532862bd56524ec6d7141c71af08b441b58d870dbb7e"
    sha256 cellar: :any_skip_relocation, ventura:        "eb75e908cefff63f2e58a4cfaeba4c753fc645ab7a8cc97ebc70653a26ab3714"
    sha256 cellar: :any_skip_relocation, monterey:       "62bb0748a3058dd47c8f14f49726e957571e60a790f8007bbf13dc54e83807dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c497311838d29ea3feab5c4f00d88227494d5b33ac2129dc6e3e8237a885800"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libxkbcommon"
    depends_on "mesa"
  end

  def install
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args, "--features", "lang-cjk"
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

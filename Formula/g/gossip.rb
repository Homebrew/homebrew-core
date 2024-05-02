class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https://github.com/mikedilger/gossip"
  url "https://github.com/mikedilger/gossip.git",
      tag:      "v0.10.1",
      revision: "622ff8c0ddaefe40830199571f5f76229ba7be5a"
  license "MIT"
  head "https://github.com/mikedilger/gossip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03efddd1f62122fec07ba65707fd541c415472d2e5e472422fa42691eaf14db8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4848a064459571acbb84c4fc4191f79832dc8f346e720585d3c39721e00173e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e90ae3a95a863df7377dbfb7446f7d05fc8f44e3910be60f9ec45234a510f83"
    sha256 cellar: :any_skip_relocation, sonoma:         "f493a55f877324339385b97602efa23f57651b371dba14aa15a76946303307e0"
    sha256 cellar: :any_skip_relocation, ventura:        "4a0537fed33a059b68fac3487478645c0534e7476cc144e9e6c18d28ae9d9e80"
    sha256 cellar: :any_skip_relocation, monterey:       "151eef7d61a43b8587f4af5cd4a35edda842909e553e068d89189e65f917abff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "466c776144591aebcb68617bb655f25624d1431f2b44459a30d3ab712ca4e4ca"
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

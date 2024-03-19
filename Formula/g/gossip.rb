class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https://github.com/mikedilger/gossip"
  url "https://github.com/mikedilger/gossip.git",
      tag:      "v0.9.0",
      revision: "f1442ae2311bcf72fb8d4e716bb6ca471a78b7b2"
  license "MIT"
  head "https://github.com/mikedilger/gossip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6afd61b29cfa91d4caa193ea09fec1f850716bffa54995f911c23ecb1cb497d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae9efbf2362876558cb738e76e143ab1fd46ae7097e6cdbd2a53dd66491d50cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba1f4e3465321b4625a237a0f0a2ac13ce66b862f8cf67881fb45ef07ef02b39"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbb0c58b374663281cc68f62b6a3700f1f250bf145d286851a09c122569a5627"
    sha256 cellar: :any_skip_relocation, ventura:        "0c2c2628a84ab45e874819f225b0a29e9c1f296baa97a85257ad4c131386c770"
    sha256 cellar: :any_skip_relocation, monterey:       "f946b18629baab8f7dc4c0429731751ed451eaf78c33c16b3dcc19428263530d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1754d6232bc345e05efc6d5242659ca695cfb481c573f01457538a27f89e4aa"
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

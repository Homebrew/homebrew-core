class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.0.19.tar.gz"
  sha256 "0dae03bc0dd05803e9a0167a7d0bd19e9206f268e7a6f41a7c5ba733e960013f"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4012120c435eda18bb895c8eab0360310749c6c03f12c97d68acf4eb0840581"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d82488a7008f204c904bda8a5b019c6865c826f2f060c374864e33642a3bd6e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "347c520dd70717935703c17fb80b6f56eda8ddc39faa6de84f89b1c031c89a43"
    sha256 cellar: :any_skip_relocation, sonoma:        "80f3f1d1e672de2e153b035d95d609528ca1d6abcfb2874660cc5f71ad4bb4c3"
    sha256 cellar: :any_skip_relocation, ventura:       "29d2fb2988b531ce67f7bdde834831dcd64047631a61e47e1d6c926798c4b588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "703284710b0df03f9e4f24e69daff2e887162d43f92331a01e568da1e958c30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95091eacf76f15bb1e0d31d0d26fff27f2abb2096b11d64cde58fc66c50f5bb2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    assert_match "Goose Locations", shell_output("#{bin}/goose info")
  end
end

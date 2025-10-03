class Chainhook < Formula
  desc "Reorg-aware indexing engine for the Stacks & Bitcoin blockchains"
  homepage "https://github.com/hirosystems/chainhook"
  url "https://github.com/hirosystems/chainhook/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "fea917fcd18032a280a965bd84b57894008110ec15191f4efca6aaab26011443"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/chainhook.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4e136b469e884c9fabfd7d76b71d162f5fd42859f549a77353bcbdd62155b38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82ff4a5ec7b4aa312786066af2837d17fc1b0ed2d330f48edb953507f533eb28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beb89ff5c70e198adff8eab6d5df70cb71dfd23880b1180159734603622caf58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "152b922139083becc46220117c5e0d231c350aaf45f26d64364cad7dfe084d41"
    sha256 cellar: :any_skip_relocation, sonoma:        "50368ff655ea8363902b44d6e6c5894c79617d6a8b4b1b69929956415c597e4b"
    sha256 cellar: :any_skip_relocation, ventura:       "95789e890d61682e76409bcab394b10516c01313f6753c487f6b7acf59b2b4ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1fb33e311ed22c4819728973a18c07e67fcf7af7efae1a1952cf2dfdd9b31c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "540c3aa91b988100dbe13c53b58ce83e9a5719e33aaa0abc006f6634079d3a97"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", "--features", "cli,debug", "--no-default-features",
                                *std_cargo_args(path: "components/chainhook-cli")
  end

  test do
    pipe_output("#{bin}/chainhook config new --mainnet", "n\n")
    assert_match "mode = \"mainnet\"", (testpath/"Chainhook.toml").read
  end
end

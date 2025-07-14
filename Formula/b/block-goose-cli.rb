class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.0.35.tar.gz"
  sha256 "3f7a535665a4147b5d590e917d0f9370bbe22bc1b8256c34cb008c2c98872ade"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45d0433c44db32e426b6259837c63c2cbb8177ec5d0d51067759c4f75f3af8cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db1a507ee6565d46c05641c84448752e53fb3b481a4bac4b9f9079c5c588bdca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "701ac729c5a21fd4229d6dd5d03f53472c8e2bb3e3504ebf4cbdfcab225e7b06"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf91e5f5b9aa300e1b38c7087d4dd05e10cced6a2292c7d575cf06cb79686edb"
    sha256 cellar: :any_skip_relocation, ventura:       "90f98f25213031b048b2f530e7814ac8b9fed7e1e101132a9082e10ca90fc675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da9261c2544bf9abc1c1654d51fd0455648b3ff5510d5af326be3edfa4c561d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8e6805169dca0b4043b05f08e1f9896870573283e570c43305c5ee7f050cef3"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
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

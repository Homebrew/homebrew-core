class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "7376bf17508a310b7f5293ec35ca10780af29fc991d3ed3baf5b51c82b37146c"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0b4d62d12dee8c593210cc8a3e7bc15ec3585217ea0bf97766daea0b5980da2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a02129b151802339383664eed0ddecd3bdf9d8eef0bbefbea8f504dda1045bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e34a2411354317eb39c2153bce15cd59c662b60fbdfedfe40bf7dd26cbac3068"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ec9dcd5a82773d8af9bfb764ab5d1db3aa0675a6f1eebf27a947b863c29cfac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48e337b8f49126244306a7013ee616efa495c1795ed14dc6e64d559a779e73bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e739b29e345db271f5d5c66de50281b2c4da32eeeec819e0d93c41e6c3e0b779"
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
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end

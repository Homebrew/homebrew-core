class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "c011f64e5505c91e77afdb4c09f3bc917677e3cd9391357accd93770133cdf67"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4003067265927a070b1a4a2da251ba2b404e516cdb39951a99d9b958b9276b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21c1d67a24aae8fcf6357081ac6a5fb2c88d1e2b29a7831b927e08107c0b381e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30184f8d055b1e932a7961ee077c292fb29f296735b1d984c101c9def22564d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2acf90837faf9c5b9a210044d475c2c03bdda74eb2d2b5970b533b4e832dbb72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5779122fa96966cf236ce9c88eae22b0766b0a21d899fd7c35a18b3a4925bf90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "214d83c0d5cfadb3b6fb18f1236876b250f971cb79f73155c92b8a0d6eadabe0"
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

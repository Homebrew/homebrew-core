class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.0.21.tar.gz"
  sha256 "f9e4ebb7f6e07f81d24b63d9d51930b8d0ab6ad23b675490eb634af8d689f695"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64d0a1667f2123a75c048f63fdb53a2d94bd16c0675e7bc27b11969acec1bf89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a37890bfa321c0306415be6ca5f0a206d3a4e34848713fde3d04f408a8418345"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b002aefe9305fd9a4182e2654095ed67727349500d2c1fc8987e0d514312ad7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2de71fd275e69a02de1013b5fd627800b00782228aa1708b7b945d6808ec57b"
    sha256 cellar: :any_skip_relocation, ventura:       "89d4ca972f2ec466682a8b82d30182cdf0bbcfa51e2c7205621095abd7ac77f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d50fc59777dd2f09e626a79b8319b7f90514ce6ced58fceab89d550255d776cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c2f38f32b42bbcf0f282502226d5998c586be2f9652394cc7541e25a2c48f51"
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

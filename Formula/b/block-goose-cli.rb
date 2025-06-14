class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.0.28.tar.gz"
  sha256 "780ec1f805038b3c5549b4c04c55770a5bb25d7a252ef00c61ee26bb873e89a9"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1899c4c918e1d37d045fcbeab1283644e894c66e180e852d62af71c766191fbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c4c7cfb8f0e1d680e2d25400e05fded24aa4cebc508d18cf51442aaa50f3347"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1a54658733c81cdcd30ebacb7c4d0d13cf7482306c865d8bc5d522dfb9bc9a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a5950b0f94b009f0f502390d3a0b30a3f1c4135f441b10144ff5d9bfa0a47ca"
    sha256 cellar: :any_skip_relocation, ventura:       "911e8d36242ae15d3a3551833904608d2c11224e4004ead19a4473d2a17a9623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a81db9d8b444cfd004d1a506bb5e66e23da126e6ccdb8da99fd87091cedc161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8c5e0d8db65353d9df7239b9dd78d5fdb2c87f07207936b680113fbda1dd2f1"
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

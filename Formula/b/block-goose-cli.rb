class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "b0b167351756036bbda740358a97ae3714f54afce6c89b995869568580bfb65b"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae51b5dc8b916cb7cca9a25bd4fd95e5b4e267e4053b33b767e752ef281a3c2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23407a70749018f1e1721f1422b3d20ae5946c57e7a6af695388996e7403ebed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8945fdbb98bc2a0300e2270f60866d706326fe47db20a458215b34f6c60d25a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e153988cffc49091badf9e201d76a56d971668b3a743cc56ff1194c434190414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b350d6b8dc403230ef58342001d4eb82f1b311dbf24379e25e21c4e61d41ad29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2fbd544f127f8b9235239955f75063448e9047b884bc30695c03072494f46d5"
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

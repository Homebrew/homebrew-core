class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "fbbdea919c9e2b1636486042dc267afd92dc462268a8e005b3f08bf1bcfbe972"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "811081b3cb55b1959e320cdd04b210b59b91f1d87ccacb233bcecbb3e4075b11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07ae0626740b9ea45947f0a57262c944ff880ad665b0bfa1a31797f01c1c145e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41e6eff2a32872ab8f64978a6fa86b381d3292ecd234ab88f8f5bae86dac7eb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "eec080b90f25f3df38d11b604aad5efebae4d092f039fb842aa87a2e49bf6d72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8544d454880db93df5bb8850367bde561d08bfd8ac185d1467c4bb2e7edeb05a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e26898d3144775201cc886a08229e6e42d8c98a83b7873defaf674c1292f04f"
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

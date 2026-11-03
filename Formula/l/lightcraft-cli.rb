class LightcraftCli < Formula
  desc "Headless LightCraft CLI and MCP server to develop and export photos"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2d4121bee0dfc5d56479b777ff6e34ee1df8638bc37eaace775b5c258f111f0c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae5aa584ec854569158b6957bcd293972be88786993f8e4e2e2001fb2e57600f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c37065cad12603d6a946d2cd29159d8c7c638850cb5638a7c4dfefa25a365946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33eabf1e1ee5125e22c7c7f1b856212c75ca4ea66187475a96bee5845a1ccce1"
    sha256 cellar: :any,                 arm64_linux:       "4cc877a71b725de33f56dd05cc5ff6132a75f0acab619305a2a7aa106eaa531f"
    sha256 cellar: :any,                 x86_64_linux:      "d588b8904cb5e9ed9d25973e6109cc1c785f9d5e659652ee37f619d2d5ae3e16"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/lightcraft-cli", features: "heif")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lightcraft-cli --version")

    system bin/"lightcraft-cli", "synth-merge", "hdr", "-o", testpath
    merge = JSON.parse(shell_output("#{bin}/lightcraft-cli merge hdr bracket-0.dng bracket-1.dng bracket-2.dng"))
    assert_equal [1800, 1200], [merge["width"], merge["height"]]
    assert_equal [-2, 0, 2], merge["evExif"].map(&:round)

    system bin/"lightcraft-cli", "render", "bracket-0-HDR.dng", "-o", "test.png",
           "--set", "light.exposure=0.5", "--size", "120"
    png = (testpath/"test.png").binread(24)
    assert_equal "\x89PNG".b, png[0, 4]
    assert_equal [120, 80], png[16, 8].unpack("NN")
  end
end

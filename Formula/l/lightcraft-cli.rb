class LightcraftCli < Formula
  desc "Headless LightCraft CLI and MCP server to develop and export photos"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "a528687d7a3431e1a20018cb1c9f75222fbddaf72c703275c1acca79b0f87a2c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "446cd7262676e5dd0fa7c8647d5f80434be8bad863cb67cd4b55f98b00401499"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c14d6e0fdbf925ffee63a08ceb67faf624ca21729b53cddb9515ace849029b3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7c3c3af2ccf71fb98f67afedf73b20030c3250651a691ddef154afacf91985c9"
    sha256 cellar: :any,                 arm64_linux:       "c4106b97e00070a825a48c228a9b687291523dbe56d7710efdcd91c670c5c78d"
    sha256 cellar: :any,                 x86_64_linux:      "deedc7b856ca4d62773ddd2cb42c46ccaf12e37e9d2fbb2a91a8c7526a293128"
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

class LightcraftCli < Formula
  desc "Headless LightCraft CLI and MCP server to develop and export photos"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "3d09c282ee23d4369a18044e810d15b55d5067da86bd6aba348289765f0f631e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47b4edb0c52937eb3857da11fcedf079c4d84ef3d42413e3825033ac4a563a10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dae6dbf9330d8918dbb15f3f0c91120c55666f93e1bb5786bd6df001cb32f745"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "820fb02224a93a539c2d2a0591bdf5f459cddaa763f735b067c4445b1b980251"
    sha256 cellar: :any,                 arm64_linux:       "c0eeea7a186f22faf2938770339b3ae1061e8848553fe377bb4ef56f1828fd86"
    sha256 cellar: :any,                 x86_64_linux:      "0111e445c20eae0ab488751f349f5e48e8b39a5e733f0f5ff1bc61d1a1187f61"
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

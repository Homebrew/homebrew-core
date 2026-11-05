class LightcraftCli < Formula
  desc "Headless LightCraft CLI and MCP server to develop and export photos"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "da592ba01b21c8a281067e223826b62e3988a0c93032297c9b23e7b8fb844baa"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ca9977d1617b4175f0b93052f7c2e89c1882420ac51348071b47600e61639f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8d90cf4f51f6afad78e4a0db155f00cd2a8cec02cd177d07f6ff7ceb3f8a778"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0db4e009da7c3d0820ee5d716ed167dcafc9c94b4cf1456a5677da8b718bab1"
    sha256 cellar: :any,                 arm64_linux:       "a6ef68d32312f7f5798e4fcdb3c4ee1daa2609409317c521f93d66486aa929e9"
    sha256 cellar: :any,                 x86_64_linux:      "8ef39833749ae7df9967981194ac61673d3a3e35fba8804e80f86853da31506f"
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

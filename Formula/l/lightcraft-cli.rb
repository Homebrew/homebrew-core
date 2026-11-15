class LightcraftCli < Formula
  desc "Headless LightCraft CLI and MCP server to develop and export photos"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "d635ea3de98b299686511b5663f6bd978353e0f491dcdbfe4b6f34267366e5e1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7cc6a5e84df5cf896e8855fcfb5e96e3cad6f52e9bf36530ffdd8e5879c55911"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "065d11b964d7f5ac1ba2bdbe7884834c955f75f31ec9106fbdc4721639e5fbd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a1e186810c2023fc46cb5587f97fd138fb92b7fffde7616c7e1889d7c871f7f"
    sha256 cellar: :any,                 arm64_linux:       "7cc2abec7610887bfdb83670e7dc809c0fbe42f96d8a0d9922de3da8b7bac5e2"
    sha256 cellar: :any,                 x86_64_linux:      "f1164ae5e32cf185dd43aa98572e486f2a69f1d68e2e4649284107bdb73b3611"
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

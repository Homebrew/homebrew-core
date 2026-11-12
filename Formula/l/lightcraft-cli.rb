class LightcraftCli < Formula
  desc "Headless LightCraft CLI and MCP server to develop and export photos"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "19ab0d1556f6a28591efa109c0695cda065204385abd14d4425727a4b6ae45f2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a26cfc1c464fe000babba80f48d047e7371c36333f447000f2e01907bf23d628"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d966f406d83faba23a41e672bd8ed3a76d7f45f4745d320c9641034241f1f2f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9866295b4cc5e749497aef4a9fc0ea69a860c315910a4a501614e058c704f712"
    sha256 cellar: :any,                 arm64_linux:       "fb3b121ad77dba8a54b41e1acc46224a6cd0812b6f34e2cf56b5fb932462cad0"
    sha256 cellar: :any,                 x86_64_linux:      "10a952a9b24afdfaaaaa21a224730a15b6d0c5fb32c145d17ab8e94a1eb38415"
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

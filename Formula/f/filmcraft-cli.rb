class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "1f442d91aa31858ddd4dec9817a466e76c6dafb47f3e402f0f8b6be467c53fe4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e2e7c3745ac0cffa86fac520fcbc6b6a752f1928620d353f382dfa4b5cfc47a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98a58ffc5aeccc4fd90ec2e51b17fdbd3a57daab0b257ba139ffb4ef7bf3e852"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edd7c8a67c18b3f7fae7e14582805a67ff78715735d6887bf6debb9fab2b1a70"
    sha256 cellar: :any,                 arm64_linux:       "76eee1ad4d781daf90bf4f28f0d5175fa299a71f6f4b07f4142c4cbac78b37de"
    sha256 cellar: :any,                 x86_64_linux:      "b52e7548255bd789d6e015615f89525966c62dcb2e474d7fbfa6c0e530927588"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/filmcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filmcraft-cli --version")

    system bin/"filmcraft-cli", "--demo", "exec", "file.newBin", "name=Homebrew Bin", "--save-as", "test.fcproj"
    assert_match "Homebrew Bin", shell_output("#{bin}/filmcraft-cli --project test.fcproj inspect project")

    system bin/"filmcraft-cli", "--demo", "export", "test.wav", "--preset", "Waveform Audio 48 kHz 16-bit",
           "--start", "0", "--end", "0.5"
    audio = JSON.parse(shell_output("#{bin}/filmcraft-cli probe test.wav"))["audio_streams"].first
    assert_equal [48000, 2, 16], [audio["sample_rate"], audio["channels"], audio["bits_per_sample"]]
  end
end

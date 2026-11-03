class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "430de17dcf3c63223064e6f23c889c6abc4a2f08f351e0c854ff518944f9b60e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e69f050f741da15524b9aa5898090e626115e9219a0c835371d7e43ea553c5d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d31503037f6710ec95405678d44593159c692cddd41fd97f7a24cb511d1fcd0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58a434764cd3380155ccc5242fcd08bc3c1cc711e44aba944c7d4afb0fccab43"
    sha256 cellar: :any,                 arm64_linux:       "6e2ea482b8445450e2e5cca425020ae17f02dc00283460082094dac77f69fda9"
    sha256 cellar: :any,                 x86_64_linux:      "b30eeeb74857be82202ffcd38f17e6f67de9126fa18f8327956be85052cee7cd"
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

class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "392e1bec5241cf6342699d316c0e87c65071ed6de2b742c1b23e5bb9e3c1916e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13cde6588c14b3ac0836149db508c014b2b464272751ac2c82584241e7a20887"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76d3b8060de0fdb99965fe13ecdcd5da6ed1facb625b8e130f2bfc3eec3872b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "392474380c678637f20d514f1767d018391a1c345af63d0f338d2fa6418699af"
    sha256 cellar: :any,                 arm64_linux:       "7372cb21ba470a9910c7eb6029d24d46d60ea95165f1480c1b8e2c5c99f245df"
    sha256 cellar: :any,                 x86_64_linux:      "9a2b8302540d8be586e44bc87c1964ca42f4a1e07a6258f7becd4a56d8407b97"
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

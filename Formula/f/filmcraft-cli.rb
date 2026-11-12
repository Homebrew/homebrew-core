class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "2ecbb8e06f7fd75fd64a7cb412368e658d2a0e25104448e0d7a84c97fe353477"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9ab471bd3dfcd5f2bbcf2807ed217749179d3f9e4d5a67b63cbed32b16a4a45"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9030e6e3f43c646cf2222def453b8cec3e0296eeb1a916c2fcff8ab2e103aa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01c665087aff1fc900fabbf4cfa720030c78eafbd18cdc1b1d5e82ec7629009f"
    sha256 cellar: :any,                 arm64_linux:       "d0b8e62645158381c70fd81ee4ca1bcfad116f75ae15a9e62450c6dad0a067da"
    sha256 cellar: :any,                 x86_64_linux:      "722a990ebce380bec5c27ce75869ee743de17dd1cbdd46d882efb3317c1a0ee5"
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

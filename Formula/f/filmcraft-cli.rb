class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "421f4a85c82a66b2b81d28feff369d2d72f63f2c2cad702d6d8e56ce5cd38665"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "feaddc24eb52ba43ccbd83ef8a57cf2215aa95cb477794b99e8eb699c923c4a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "635be5a2c49532fc526684041c90fcbd3487559396be7c1e09b7e564f4e48005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70eed49586c4c0569b7f548b954a5ece5cb3656f02e8ae055d8da800a3a887b4"
    sha256 cellar: :any,                 arm64_linux:       "c4d29db5b704a0a9f1dcedad90df91964f2d4c40effd210535a3bfe67d7d43ad"
    sha256 cellar: :any,                 x86_64_linux:      "4173b33b299f33eb55059ebe86b283307a4e72471b8cf5b37b0a4490cd2d552d"
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

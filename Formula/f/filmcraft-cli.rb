class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "eac7deaf130bd48650b20d1ab860e94605932301e2473dd786ae842a0e33521b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ccfaf36730c1d61088e2d8ab8cc1512089fe9093d0c310529220c97637aa0507"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d1c40a85a36e268296dea865470c42dc224439cb5563ba89ed5337147b08cb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f39f8de277749b587e23987f041a05a6805ad8d7b9f8458c6393a1241ebfe830"
    sha256 cellar: :any,                 arm64_linux:       "abca0a1fb1b1ae260d4c47f7204a58fc67b09e8d79eaa8d90ccfb91aa32976e0"
    sha256 cellar: :any,                 x86_64_linux:      "4c43860a4093fbaabb4f1418d0a49ca0acb8d7f8db4c599dfbd657c3578fa495"
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

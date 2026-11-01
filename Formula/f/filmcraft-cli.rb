class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "eac7deaf130bd48650b20d1ab860e94605932301e2473dd786ae842a0e33521b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "939b5858adf9e3ee0e09a276ac745cc048d1104ce66559a7bf976af39ab073e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2df5f4703bcf8b352446633db970bbed03942d97f1da653a6449a2bf86e1ad59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc3baad2cc76f871b3acbcdbfd7e685adeabb8d04570e48af956bafaf6c349f6"
    sha256 cellar: :any,                 arm64_linux:       "c301a9c859713c0fbe63bafbf2d65f62d7ea137ed668e9ca07302187feb04419"
    sha256 cellar: :any,                 x86_64_linux:      "d4e8b4ff5ef951ec8e4e9b7dd8db83a568350c5a389873a1968baee8a2937716"
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

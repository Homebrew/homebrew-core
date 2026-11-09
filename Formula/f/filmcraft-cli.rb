class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "dd595bda36d4d7c8384020ce7ed6bd81f9a789c9f5d34f012d1d02c07186d543"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97f479ca24e0aec8e7f061f4680854878698ec9b13ab2a98d413444d06aeefc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "51c7f50e3bd5514e70870a77e097ff6f9d6aeb389312ca5f3d3e7ae9096c2ba0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26b528e1f3ee6f849bb3568c8cc5c7cec8354c1962ca0269ae071fd71d6640eb"
    sha256 cellar: :any,                 arm64_linux:       "1b0cca0f0895ae57ff969f0c5fd052207b26fa2dfd8927e82abc47bc2df8d144"
    sha256 cellar: :any,                 x86_64_linux:      "198999a86893eac9ca0c7ed0fa76f4b66a16c730a9ce81c40c8a084f7fd75547"
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

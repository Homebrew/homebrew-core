class Asak < Formula
  desc "Cross-platform audio recording/playback CLI tool with TUI"
  homepage "https://github.com/chaosprint/asak"
  url "https://github.com/chaosprint/asak/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "da90a31924a6ac7ed06fa54d5060290535afdfe1a6fc3e69ad1ed5bc82757e92"
  license "MIT"
  head "https://github.com/chaosprint/asak.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79e247315c14b0a29016ba9856f673d877229af3a7aa4755cc9887ea110b2b20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01a324c75ba86d32ba07a3184d83921bf05824aaf2c327a5e6c423498969f1c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feb576b39f6c74a6876b14a0fa28f5560e1dad477831965465f44a68d465ed5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4755f43dda07d16847f7a153ea3c6832c0b6de12c4ebf0dfa53d52bc5e48bfee"
    sha256 cellar: :any_skip_relocation, ventura:       "2d605e4e59e4c111c890547a42f9634fe4781b4b025cd2e8a61f645fafec0d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a7dc3b8e3729bc5d1d9cd7e35a701187334e6da2f80e02eece663b1d4ec6c9d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "jack"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "target/completions/asak.bash" => "asak"
    fish_completion.install "target/completions/asak.fish" => "asak"
    zsh_completion.install "target/completions/_asak" => "_asak"
    man1.install "target/man/asak.1"
  end

  test do
    output = shell_output("#{bin}/asak play")
    assert_match "No wav files found in current directory", output

    assert_match version.to_s, shell_output("#{bin}/asak --version")
  end
end

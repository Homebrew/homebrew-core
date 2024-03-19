class Daktilo < Formula
  desc "Plays typewriter sounds every time you press a key"
  homepage "https://daktilo.cli.rs"
  url "https://github.com/orhun/daktilo/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "55aead933dfe9176bc6f55f397bfe05f5eb97ef0f2b06e6904e4227f3e715b70"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e1b4b6e48a02126163228cd965c1b082dd3d114680e74e8cbcc69d94c857b70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2283e58ba4a9fe33b0d33625d2fee746e78daecfbaa122fb6c60eb5e34eb46bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "793ac3882df541a8d636220508e9bbdade45f783ce83f6c1f3b87f352e92931e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e4f84409ea2a9785d4f7475785574e914667881b7942bbbdf128fa061b9a2da"
    sha256 cellar: :any_skip_relocation, ventura:        "b279323b66da0d36d4002df97daa20fb7b0391532e48a15197efc73813be19dc"
    sha256 cellar: :any_skip_relocation, monterey:       "2ce69ab3ec4924b6c75b8f716c133b5d82a87ea057493d7c3ed08e0f0e316169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2deb6b60aa7790cb37fbbcd1f1c6c5377eba439972191ccb9e76f27483dae23e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxi"
    depends_on "libxtst"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/daktilo --version")

    output = shell_output("#{bin}/daktilo -l")
    assert_match "kick.mp3,hat.mp3,snare.mp3,kick.mp3,hat.mp3,kick.mp3,snare.mp3,hat.mp3", output
  end
end

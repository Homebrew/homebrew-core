class Fnt < Formula
  desc "Apt for fonts, the missing font manager for macOS/linux"
  homepage "https://github.com/alexmyczko/fnt"
  url "https://github.com/alexmyczko/fnt/archive/refs/tags/1.7.tar.gz"
  sha256 "3178f901090c9ab035328dcf1d91d08500a37e30da91b76c95169cb6c800be08"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a14fd1494446ef6b6af8aac38d685b8b2295cc3027b80dfc26743d999bbb2af9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a14fd1494446ef6b6af8aac38d685b8b2295cc3027b80dfc26743d999bbb2af9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a14fd1494446ef6b6af8aac38d685b8b2295cc3027b80dfc26743d999bbb2af9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdaa6c85e1cfd5461678b089d76c61e6639b028e3f3623a11423d2cc7f33799b"
    sha256 cellar: :any_skip_relocation, ventura:       "bdaa6c85e1cfd5461678b089d76c61e6639b028e3f3623a11423d2cc7f33799b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a14fd1494446ef6b6af8aac38d685b8b2295cc3027b80dfc26743d999bbb2af9"
  end

  depends_on "chafa"
  depends_on "lcdf-typetools"
  depends_on "xz"

  def install
    bin.install "fnt"
    man1.install "fnt.1"
    zsh_completion.install "completions/_fnt"
  end

  test do
    assert_match "Available Fonts", shell_output("#{bin}/fnt info")
  end
end

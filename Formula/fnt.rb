class Fnt < Formula
  desc "Apt for fonts, the missing font manager for macOS/linux"
  homepage "https://github.com/alexmyczko/fnt"
  url "https://github.com/alexmyczko/fnt/archive/refs/tags/1.4.1.tar.gz"
  sha256 "263edd4e3ebd71bb5c63e5f063bfbed6a711b5786e6f6174c6ee586e530c1727"
  license "MIT"

  depends_on "chafa"
  depends_on "lcdf-typetools"

  def install
    bin.install "fnt"
    man1.install "fnt.1"
    zsh_completion.install "completions/_fnt"
  end

  test do
    assert_match "Available Fonts", shell_output("#{bin}/fnt info")
  end
end

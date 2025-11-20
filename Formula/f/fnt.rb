class Fnt < Formula
  desc "Apt for fonts, the missing font manager for macOS/linux"
  homepage "https://github.com/alexmyczko/fnt"
  url "https://github.com/alexmyczko/fnt/archive/refs/tags/1.9.tar.gz"
  sha256 "4801b58e007aa5d84b112afbea3a5e449fb8d73124fb34182efe228fc37ac3e0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7643970e5f382eee3b375961250697f97f3699b4d6372629ec8aeda86826ddde"
  end

  depends_on "chafa"
  depends_on "lcdf-typetools"
  depends_on "xz"

  on_macos do
    depends_on "md5sha1sum"
  end

  def install
    bin.install "fnt"
    man1.install "fnt.1"
    zsh_completion.install "completions/_fnt"
  end

  test do
    assert_match "Available Fonts", shell_output("#{bin}/fnt info")
  end
end

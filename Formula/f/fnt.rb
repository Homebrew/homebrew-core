class Fnt < Formula
  desc "Apt for fonts, the missing font manager for macOS/linux"
  homepage "https://github.com/alexmyczko/fnt"
  url "https://github.com/alexmyczko/fnt/archive/refs/tags/1.9.2.tar.gz"
  sha256 "a3c4c17bb891d773dbf6cccb9479d8d436bb83d4c3d57d7e333a8db8cb9f11b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ed3b35accff93ac93a66169e9a2501a71d81428dfb85d6e6a97c6e3420c462a"
  end

  depends_on "chafa"
  depends_on "lcdf-typetools"
  depends_on "xz"

  on_sonoma :or_older do
    depends_on "coreutils" # needs md5sum
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

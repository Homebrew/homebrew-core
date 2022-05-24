class Fnt < Formula
  desc "Apt for fonts, the missing font manager for macOS/linux"
  homepage "https://github.com/alexmyczko/fnt"
  url "https://github.com/alexmyczko/fnt/archive/refs/tags/1.4.1.tar.gz"
  sha256 "263edd4e3ebd71bb5c63e5f063bfbed6a711b5786e6f6174c6ee586e530c1727"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d674614b1b87af4d7af534169e5e7f6146f605e78d54ccada7b32ae2afabd5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d674614b1b87af4d7af534169e5e7f6146f605e78d54ccada7b32ae2afabd5a"
    sha256 cellar: :any_skip_relocation, monterey:       "504e678ddcb9adb26de967a20e6e5691d68a3a8024de98b81c6c66123c80b9f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "504e678ddcb9adb26de967a20e6e5691d68a3a8024de98b81c6c66123c80b9f1"
    sha256 cellar: :any_skip_relocation, catalina:       "504e678ddcb9adb26de967a20e6e5691d68a3a8024de98b81c6c66123c80b9f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d674614b1b87af4d7af534169e5e7f6146f605e78d54ccada7b32ae2afabd5a"
  end

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

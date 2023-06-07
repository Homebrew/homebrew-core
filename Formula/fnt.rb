class Fnt < Formula
  desc "Apt for fonts, the missing font manager for macOS/linux"
  homepage "https://github.com/alexmyczko/fnt"
  url "https://github.com/alexmyczko/fnt/archive/refs/tags/1.4.1.tar.gz"
  sha256 "263edd4e3ebd71bb5c63e5f063bfbed6a711b5786e6f6174c6ee586e530c1727"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3354ea71f3c637ff74666a5561a77b6c717bfc319c96682cb6affc7593fe5cee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3354ea71f3c637ff74666a5561a77b6c717bfc319c96682cb6affc7593fe5cee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3354ea71f3c637ff74666a5561a77b6c717bfc319c96682cb6affc7593fe5cee"
    sha256 cellar: :any_skip_relocation, ventura:        "fd63e7162fbaa82f98a00c390f07d2860c5732a22194abd0f4b3b2550c36fd96"
    sha256 cellar: :any_skip_relocation, monterey:       "fd63e7162fbaa82f98a00c390f07d2860c5732a22194abd0f4b3b2550c36fd96"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd63e7162fbaa82f98a00c390f07d2860c5732a22194abd0f4b3b2550c36fd96"
    sha256 cellar: :any_skip_relocation, catalina:       "fd63e7162fbaa82f98a00c390f07d2860c5732a22194abd0f4b3b2550c36fd96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3354ea71f3c637ff74666a5561a77b6c717bfc319c96682cb6affc7593fe5cee"
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

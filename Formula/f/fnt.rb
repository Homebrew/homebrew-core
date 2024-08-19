class Fnt < Formula
  desc "Apt for fonts, the missing font manager for macOS/linux"
  homepage "https://github.com/alexmyczko/fnt"
  url "https://github.com/alexmyczko/fnt/archive/refs/tags/1.6.tar.gz"
  sha256 "fc799acaa3cb9d038b26d753fb86e8cc5c09ffc3f3164c458b4d84827494c81e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6cd82cb4d413c71869f4dca03328912c5f32f6b1f1e30fb229cc39cb9e972c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6cd82cb4d413c71869f4dca03328912c5f32f6b1f1e30fb229cc39cb9e972c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6cd82cb4d413c71869f4dca03328912c5f32f6b1f1e30fb229cc39cb9e972c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a55fcbfa443ac93d1171748db6e6edafde0040f83d6ec1270a6a475af8104fb2"
    sha256 cellar: :any_skip_relocation, ventura:        "a55fcbfa443ac93d1171748db6e6edafde0040f83d6ec1270a6a475af8104fb2"
    sha256 cellar: :any_skip_relocation, monterey:       "a55fcbfa443ac93d1171748db6e6edafde0040f83d6ec1270a6a475af8104fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6cd82cb4d413c71869f4dca03328912c5f32f6b1f1e30fb229cc39cb9e972c3"
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

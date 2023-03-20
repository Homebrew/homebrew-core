class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.9.tar.gz"
  sha256 "1e9c1edb79c1a57830356641b0a2d232f15585416fd1dc8200b4ff808db118ee"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09bc778ef4523c9eeee8adbbf316d76822b7afa9f771a6497eb415e2a46cf62d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "393fc01b8719d4ab855068ae0da3e49567849e619aed6ad6f24d10f605c67c0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e33631407dc9bbd6afeef9fe590f3d1f66c59b102d4d677800c842a15dad934d"
    sha256 cellar: :any_skip_relocation, ventura:        "9edb1712c2b005df8b0cf3fe50c9126bd5c199c6589c033d2acb46cb6bcb31bb"
    sha256 cellar: :any_skip_relocation, monterey:       "eee3ff3bc4eee669ed068436d31372c3db7c9e55386f7a8f6aa15028ca42b894"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca5ebdc6953f6a7df61a4e75158825ef52c5ab580883bbf5bb8f3adba30f71bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c6f76ce1496777171f94cedfd7063bb32320dc2f0f9e8940872dd4b9ef21672"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/hwatch.1"
    bash_completion.install "completion/bash/hwatch-completion.bash" => "hwatch"
    zsh_completion.install "completion/zsh/_hwatch"
    fish_completion.install "completion/fish/hwatch.fish"
  end

  test do
    begin
      pid = fork do
        system bin/"hwatch", "--interval", "1", "date"
      end
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "hwatch #{version}", shell_output("#{bin}/hwatch --version")
  end
end

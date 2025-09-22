class Keypause < Formula
  desc "Pause/unpause keys on macOS (CLI tool)"
  homepage "https://github.com/elijahfriedman/keypause"
  url "https://github.com/elijahfriedman/keypause/releases/download/v1.0.0/keypauseapp"
  sha256 "62549f54d66001a759a6bdce0a991449b39ba4ef0eac3cb913f5a51c3fed79a2"
  license "MIT"

  def install
    bin.install "keypauseapp" => "keypause"
  end

  test do
    assert_match "Keypause", shell_output("#{bin}/keypause --help")
  end
end

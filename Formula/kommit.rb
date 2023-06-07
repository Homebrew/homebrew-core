class Kommit < Formula
  desc "More detailed commit messages without committing!"
  homepage "https://github.com/vigo/kommit"
  url "https://github.com/vigo/kommit/archive/v1.1.0.tar.gz"
  sha256 "c51e87c9719574feb9841fdcbd6d1a43b73a45afeca25e1312d2699fdf730161"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1fdd89c3c3c5e6c30817ddfa6e41ae587f80d05afe22b729fa4de0541e28e5a8"
  end

  def install
    bin.install "bin/git-kommit"
  end

  test do
    system "git", "init"
    system "#{bin}/git-kommit", "-m", "Hello"
    assert_match "Hello", shell_output("#{bin}/git-kommit -s /dev/null 2>&1")
  end
end

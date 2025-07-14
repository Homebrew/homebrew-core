class Kommit < Formula
  desc "More detailed commit messages without committing!"
  homepage "https://github.com/vigo/kommit"
  url "https://github.com/vigo/kommit/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c51e87c9719574feb9841fdcbd6d1a43b73a45afeca25e1312d2699fdf730161"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e27d05c078699c3a5c3ba379e6a598cd4b96142358bf41fca14cf2faa83251ff"
  end

  def install
    bin.install "bin/git-kommit"
  end

  test do
    system "git", "init"
    system bin/"git-kommit", "-m", "Hello"
    assert_match "Hello", shell_output("#{bin}/git-kommit -s /dev/null 2>&1")
  end
end

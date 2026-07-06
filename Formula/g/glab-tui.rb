class GlabTui < Formula
  desc "Terminal user interface for GitLab and GitHub"
  homepage "https://github.com/rcieri/glab-tui"
  url "https://github.com/rcieri/glab-tui/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "907b3b5b7464148c6b5c71a8d146bed5d66c710431b45c6118d7e649094015c3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"glab-tui", "--help"
  end
end

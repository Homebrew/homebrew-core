class Leetup < Formula
  desc "Command-line tool to solve Leetcode problems"
  homepage "https://github.com/dragfire/leetup"
  url "https://github.com/dragfire/leetup/archive/v1.1.0.tar.gz"
  sha256 "33e4be4278c72d09a8f20615aa4dbf272ea3087750c3ba31bdaadada4cf57bc1"
  license "MIT"
  head "https://github.com/dragfire/leetup.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Easy", shell_output("#{bin}/leetup list 'Two Sum'")
  end
end

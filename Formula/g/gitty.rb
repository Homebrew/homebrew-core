class Gitty < Formula
  desc "Contextual information about your git projects, right on the command-line"
  homepage "https://github.com/muesli/gitty"
  url "https://github.com/muesli/gitty/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "cea3f7fa92653abd18ce951f24c64321edab8d8da9340f764c25cbfe8eba36ef"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.CommitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "does not look like a valid path or URL", shell_output(bin/"gitty", 1)
    system "git", "init"
    system "git", "remote", "add", "origin", "https://github.com/homebrew/brew.git"
    assert_match "please set a GITTY_TOKENS env var", shell_output(bin/"gitty", 1)
  end
end

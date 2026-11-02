class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.127.0",
    revision: "2e352a17e7e00bef420b0f38e0ce9ab4e1a38e5d"
  license "MIT"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "64365581b5473ca3e4bac17e00e18485035bb1dd8819bffcfadd932d9ec65fdf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64365581b5473ca3e4bac17e00e18485035bb1dd8819bffcfadd932d9ec65fdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64365581b5473ca3e4bac17e00e18485035bb1dd8819bffcfadd932d9ec65fdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd9b90796eb620a87d49f51c9bdb69aae1946e9db97862043d43b4b30c507c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a2d89db7dcd6d4b28c2db1337826fdcc47dbda80a84d1cfe01fc91ffea583ee6"
  end

  depends_on "go" => :build

  # `test do` block queries the GitLab API
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end

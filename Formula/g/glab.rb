class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.89.0",
    revision: "c6fca530978d1b608113db8cce8ab99aa34bafb4"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1622fcbdc33b9f6aecd88486348dade935999fe731dc5cba3e45e6e8c40a7f67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1622fcbdc33b9f6aecd88486348dade935999fe731dc5cba3e45e6e8c40a7f67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1622fcbdc33b9f6aecd88486348dade935999fe731dc5cba3e45e6e8c40a7f67"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b6fcda200b5f3e73f11622af14a646520ef30c1ae746fd012de4c5eec53c59f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "104a5d934b15cc23ef2e045815964cd11cde9ddf6eb6ca886e851417a04de4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d73c4da056e35524cd3259139a76f744d06fc8ac20ca99ba10b795353030a1f"
  end

  depends_on "go" => :build

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

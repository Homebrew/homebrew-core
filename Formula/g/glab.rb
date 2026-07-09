class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.107.0",
    revision: "85b59ceb77434c988fead857a372691868aba6d7"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eff6c35b3b98557a32fd38745db141a51002235209cd71d9009d2130bbb53718"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eff6c35b3b98557a32fd38745db141a51002235209cd71d9009d2130bbb53718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eff6c35b3b98557a32fd38745db141a51002235209cd71d9009d2130bbb53718"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb862d4f588917160904096063b0ac6a46675e2fe60fd44eca8c904bddc7b012"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0930c5ed4620d867a6a8ea93c9fd179254f76a397e13396e7a4ed2aebf33bea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7ade1cf2abc0e5932e6b0b3d90cfda5307f7520b554cf95ef0d003ec5e5f597"
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

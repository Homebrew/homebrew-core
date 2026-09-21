class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.118.0",
    revision: "570955d4252f860d6b0cbf3fd2ec44f86a7e6957"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df4ec0e4ca48926efb356b456470dc3205ce78f7ee93ef1f7afd68700c6f4f3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df4ec0e4ca48926efb356b456470dc3205ce78f7ee93ef1f7afd68700c6f4f3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df4ec0e4ca48926efb356b456470dc3205ce78f7ee93ef1f7afd68700c6f4f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "51d475b732b948ba311d1189d1b3edd128b8db383ffbe972d9d721ce59575dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e6023f88cec92e16ae887a9ba4f7f499a089254d0a1d8e33df0a10d4d641a926"
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

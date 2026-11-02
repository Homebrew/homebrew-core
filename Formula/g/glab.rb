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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a324230cce37bf49dbfc5b264776d6a602431bfdd667c0baea7e8eacb924d110"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a324230cce37bf49dbfc5b264776d6a602431bfdd667c0baea7e8eacb924d110"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a324230cce37bf49dbfc5b264776d6a602431bfdd667c0baea7e8eacb924d110"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "31a6145aa1ae76b07cc4e7e01a8bc24ed7568aaffa934b28b6904da13797538d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d3896045832145499e602a4658b9ad527e43b482c4ffd6b831a2706953a6ac05"
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

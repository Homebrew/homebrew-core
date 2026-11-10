class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.130.0",
    revision: "9b430a11f95ec78d87f19be071d1c381d8803630"
  license "MIT"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9629fb44aed04073f859ce5a9f45882fc7cb9522e0a5327ececd76aca3a42b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9629fb44aed04073f859ce5a9f45882fc7cb9522e0a5327ececd76aca3a42b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a9629fb44aed04073f859ce5a9f45882fc7cb9522e0a5327ececd76aca3a42b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7edb5980d49b2b4b42c3c4b5e1ae05d8464334d4a9bb8fc0fff0360eaea1a800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "292ae2a0aea550cfcab67f02eae9018d64b3277d117a1a5cf5cada569f66458a"
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

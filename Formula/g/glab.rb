class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.128.0",
    revision: "519ea19f7d3e9c701a4063f277ae27254bbafdad"
  license "MIT"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "248c2fc99d65820c26ec8d4672e00043ef6ddb1dce0f2d3e0543ddfd5305871b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "248c2fc99d65820c26ec8d4672e00043ef6ddb1dce0f2d3e0543ddfd5305871b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "248c2fc99d65820c26ec8d4672e00043ef6ddb1dce0f2d3e0543ddfd5305871b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b13a3ef38199e99752a4669e3a5ac636226f558da6ef0d7fd8991ac59d97dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "79a41dba9b93fe6c96675dd072dcef10f6c72c7cbe73c74386b0cd77ffb69f7d"
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

class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.124.0",
    revision: "d43ccacecb043b0c060dd13224cf993140db6c2b"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dfec70ce214e9363f4b50cc7e5586d6ae2368c286229c00074f8c019c26981db"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dfec70ce214e9363f4b50cc7e5586d6ae2368c286229c00074f8c019c26981db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dfec70ce214e9363f4b50cc7e5586d6ae2368c286229c00074f8c019c26981db"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1c1023237cd67c14350aa108326f337bc0f42e482f263eee3cb5b68fae0fd6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "736867520615049e8e914c09063420656a1792020b39d4a56e9be896d5b59823"
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

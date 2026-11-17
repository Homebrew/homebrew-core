class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.131.0",
    revision: "206ebab4fc3fa590b720d2885ac890c195c46650"
  license "MIT"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48283ac86539126c2a05ae9dce370126505f33cc8aa4fa09ec3941b26b8c6ca1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "48283ac86539126c2a05ae9dce370126505f33cc8aa4fa09ec3941b26b8c6ca1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48283ac86539126c2a05ae9dce370126505f33cc8aa4fa09ec3941b26b8c6ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8856f1564bd5ebd488637789399391a199763ae32dae53a30ee508f594e68e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "de827854827b8fff72f888ddbbeb5bc220b5690f85c982fbc15db03621cd9a3b"
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

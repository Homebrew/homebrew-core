class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.77.0",
    revision: "edbbb7396a12a2b4c10b609004fcf0b5351bcf66"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff1728fc607c88e8c789eeebd659d4aa4e2c620923f5461f2e1df8eab301a7fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff1728fc607c88e8c789eeebd659d4aa4e2c620923f5461f2e1df8eab301a7fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff1728fc607c88e8c789eeebd659d4aa4e2c620923f5461f2e1df8eab301a7fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d122250bff01913c0ed6f3b55811bcb955eecedcd5ed9d23744d7bb8cc7e9e3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38908e804e18f6770077e6a20eb8b174c37327f2e53845c7bf907550f9075cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "943bf7c1350d4c96b1891eb3ce508414bcc6d584b1d881dca0413074ec7b659b"
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

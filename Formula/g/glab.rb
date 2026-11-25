class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.133.0",
    revision: "093bdd1b82d84dd066eefc9fac91d382e3128899"
  license "MIT"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "db60e586ee69e7618faa051af2f88e5602bb19aada0ebc05946b773580b409c7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7110482feb20436bf3a1db1049fcd5bbdf9c0a72338d0759ed1de919da82ee0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7110482feb20436bf3a1db1049fcd5bbdf9c0a72338d0759ed1de919da82ee0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7110482feb20436bf3a1db1049fcd5bbdf9c0a72338d0759ed1de919da82ee0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d4b28e03c9c93f3d61581349c6ecf0dadf0edc2ec25f76e72ace953b6dbc2931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "167e2f50210ed1193f7776070efe632f3a91ee3150e6b3439c2b46675d6c907a"
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

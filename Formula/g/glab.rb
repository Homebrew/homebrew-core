class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.86.0",
    revision: "1ef884a62788bb515880e811ef3d782b1c506a67"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd2a16c5ab685fee9dabc6d352e91ef187eae8cc7273dc510295ec838991a43d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd2a16c5ab685fee9dabc6d352e91ef187eae8cc7273dc510295ec838991a43d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd2a16c5ab685fee9dabc6d352e91ef187eae8cc7273dc510295ec838991a43d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b506e25ade91549d3000462216947fb21a69f22831208baf3fc34119eb81af72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adcb1692f375c5b0d2d92b3733fe04b3b7a0744f318d11f98e6653d98444e630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56d4d3695259b61412bbf5d16ef4082ec906d0fdb3996b1dc14a9bea36aa387f"
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

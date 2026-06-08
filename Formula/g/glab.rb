class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.102.0",
    revision: "b5a548b340b302bbe0b8828b103a9ef0433d3201"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fcff413fd654ea2d0c716196256831cf0b46bdafd18afbaeb2ad8b2bb76383d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fcff413fd654ea2d0c716196256831cf0b46bdafd18afbaeb2ad8b2bb76383d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fcff413fd654ea2d0c716196256831cf0b46bdafd18afbaeb2ad8b2bb76383d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7416bc1971a9139d25bc69145a34387ef680af0c8edbe73af3a89c6a93a2f678"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8140dd4654541e59beddf875bff2b111dddd70fa3065c1ad45db1173ba73774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9096d2a453aceec83da73bfb87a2e6b3bd476e203295afeb7b859587cc1b9ef4"
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

class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.30.0/cli-v1.30.0.tar.gz"
  sha256 "d3c1a9ba723d94a0be10fc343717cf7b61732644f5c42922f1c8d81047164b99"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5abcac380f2b94b32cd4b11ef6901069f9ffd7ef5888a604b8dc498245b55c52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5abcac380f2b94b32cd4b11ef6901069f9ffd7ef5888a604b8dc498245b55c52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5abcac380f2b94b32cd4b11ef6901069f9ffd7ef5888a604b8dc498245b55c52"
    sha256 cellar: :any_skip_relocation, ventura:        "b3e408c836801f77f73991e0eebe34dc10b5b23538aee55d4a55563818ce3430"
    sha256 cellar: :any_skip_relocation, monterey:       "b3e408c836801f77f73991e0eebe34dc10b5b23538aee55d4a55563818ce3430"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3e408c836801f77f73991e0eebe34dc10b5b23538aee55d4a55563818ce3430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18310e243ae7afa83af7437ac61fe0710a946bd9bf431e73601ef79f4aea2759"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
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

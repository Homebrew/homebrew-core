class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.93.0",
    revision: "a38e633f06ce696b8d70fe43b1e482d3dc5be3fb"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dec8f6d6080a5cc902401bb15775197f993b2ece54877d82b7a475725139086"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dec8f6d6080a5cc902401bb15775197f993b2ece54877d82b7a475725139086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dec8f6d6080a5cc902401bb15775197f993b2ece54877d82b7a475725139086"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4a6b5e952a6c1eb7a55b4dc13da022dc2613d8dc3cc88db19318032038ada54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad6c9fc6e76b0068ebf972559f07efee36b6dca084777f43bd1b965c326077e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d31d7472a9a03d916f51450d3cb3d7a46ef34b96e1f43e4df88362f79a102a6"
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

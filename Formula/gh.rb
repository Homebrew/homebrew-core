class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.7.0.tar.gz"
  sha256 "8d737d4e4a2943ca6e08c030c0992468162de0fc1366862d101b8e1389bdc36a"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d32a887a30c3f785273e9dbea0f8c9ec49b2d2170a30ea9bd8031bb72591ca4e"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd2348f88bc1a6f19a5d6cb3eed39a69e6f62a8cdfe52b03b16d93116aa8ec63"
    sha256 cellar: :any_skip_relocation, catalina:      "4bc94577622fc8f583bbec286a7f485864cf402d0fb5dfa2621bb6485218b495"
    sha256 cellar: :any_skip_relocation, mojave:        "f35ececf6bd07dcacd8911037becda9f4c6be4345013889e4913d340b5cd054c"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end

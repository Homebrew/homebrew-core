class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.6.0.tar.gz"
  sha256 "1b7a9c74f476310e2b22c46ee6a036dd73a628326bc3dc80b07014d99cc80689"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41dfc99e72e47bb0a96fae9d7694fd081f309d8cadc1a30f51e38e8ad2ea5d5a"
    sha256 cellar: :any_skip_relocation, big_sur:       "b7cc2f2572ca67b64313f751e096180f938640c83e3b894d6b8a7decf717d552"
    sha256 cellar: :any_skip_relocation, catalina:      "f57eae8d861c55b40c2b613b45b1a6d0e17987cd995d7b851f1ca9ca8809d216"
    sha256 cellar: :any_skip_relocation, mojave:        "ebd7caca02b77e13437f4b9835206e8398095423a33c304cb55d2e90be30fd61"
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

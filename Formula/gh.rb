class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.5.0.tar.gz"
  sha256 "4e9d1cbcdd2346cab5b7fc176cd57c07ed3628a0241fad8a48fe4df6a354b120"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3238ed5f3fc27fed2193767c1f29802e0c697c739a6298350e6997d55704229d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5922c570e2750d981bc23bd1fa8971ff02b01ce73003289c9ed4b3b6099bab9b"
    sha256 cellar: :any_skip_relocation, monterey:       "848a742c640ed1e0b5ef7fda3358ae39b20c8b322d4f12f7b6cf6ad1ceaf531b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0dac1d12c2a1deb146f53ef634b881029736e4ad090b00dcf0244be860b24dc"
    sha256 cellar: :any_skip_relocation, catalina:       "224248ff05a643967a86a83037f2e18562ce6aafcb9e5b2e00adf32bc308a4e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c5ef9911fbe7f84e7fc64761b8c749de9c2eb9e45a70633244ce4aca5978222"
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

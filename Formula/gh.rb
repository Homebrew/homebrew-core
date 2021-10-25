class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.2.0.tar.gz"
  sha256 "597c6c1cde4484164e9320af0481e33cfad2330a02315b4c841bdc5b7543caec"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8007a46892b80289778482989518b44838b8d01b9cb6a36e86c048db73481505"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c8a4aa91eb91928477e578168a32866098bd9d4dbca17caf39cf1b921925039"
    sha256 cellar: :any_skip_relocation, monterey:       "69e770d201f89f8c18eea5d4a426852e8b94830c0d9ee40867ddedd9dbcba104"
    sha256 cellar: :any_skip_relocation, big_sur:        "62c1fa920d386d9cf5893643830319abad097e39d798e966c102c64a79f2b859"
    sha256 cellar: :any_skip_relocation, catalina:       "002847accc5930067182092649b6976cbbae09e84c70d9389f25bde1b9dd2ff3"
    sha256 cellar: :any_skip_relocation, mojave:         "242f3cdea693b1f5eb0896120367d9c2db1051b8b475ae48571f9479bba066ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0df8a2a2e73cedb7775e4c2b38edf81ff28424e708812b1c471179723c82b08e"
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

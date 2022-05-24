class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.11.1.tar.gz"
  sha256 "7acb4097c329686ba07836d13bc45c1d269c7d7690b3bd9212e38072c22c8520"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ba4c8550da2b40e0f80e01089cdf023741b0fc36dc8a931e0e8333307a40a45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1720f9453cad464ac779cd4c2905cd4f4250f9ed55d6639df8898606836e887e"
    sha256 cellar: :any_skip_relocation, monterey:       "0cd3502ab34fd6fb15034037af200f67835d494d19720a0cff2d1dd49b0e3cd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "45b8f8029c098d2fb72fb9f72f9e0e46d15bf779bb062851ff01b2fad9edfe71"
    sha256 cellar: :any_skip_relocation, catalina:       "8ff02f9fd311b9da7a6c68548a12fdd713c686387a23dbfef045b0bd2575b506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17606debf868eac4c2be8bad4e45bcb03043f610279d246e45cd19cc27de2a92"
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

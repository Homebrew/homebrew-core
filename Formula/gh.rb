class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.5.2.tar.gz"
  sha256 "cbf22fea4574047ca3a356ee4ef629d62b872f4c4ff4e4b78fe4f89ca431858e"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "709c1387709be0afdfe2c7ed44eeb9fd51c66516002518fffd29c8b50ca43631"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71d7cf81d87062f25170183931cddab0b064202abb562273cb6194c737fb3943"
    sha256 cellar: :any_skip_relocation, monterey:       "d98f6a232a92b8bf7b2ef38a5ecaf05357d83062f5d65fb558cdd6a85a58627e"
    sha256 cellar: :any_skip_relocation, big_sur:        "058f522856949348778c0b29c6a3562ca859d8a5e5663bf87c4a22b7806415cc"
    sha256 cellar: :any_skip_relocation, catalina:       "d65fe8d6e4ede5159da1f39f6aa2c6909d04eabb8ff006a449a08c8c0f537fde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0501de9bfc41637573a4f3c80a85fddaf9938d1ccc3af9a51b14fa74d7c7274a"
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

class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.40.1.tar.gz"
  sha256 "0bb2af951b4716067747184b5b5bbd90c270edee5b45a84e62a5a803bf7ef467"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71b0a4b8b636d7d8684820b41645272dadcceb6ea8a4ec99e3bf26ecffad0a8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cb0895e4aab2fa75ff36965c172cd61dea1b7633f1a15dd47d5f00ed05f2789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b929e41cb17f466903b66e00a33ee31ac6d6111a7f9a2ea68efa9e73c3ffc632"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cc1593a897c610f3086ab8a5ce100e7186072016ceaf045f403a05d0ba7732a"
    sha256 cellar: :any_skip_relocation, ventura:        "a2e3e8b3c1ecce69938b7f9b689ce5ffb142b6f82f8250c61849b70ce09edc8d"
    sha256 cellar: :any_skip_relocation, monterey:       "1b0f6afa04716a4e227bf52f1360dada63e0ce6c36c97340a484662605ed0a3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeaf38c711233f19b1d2229ce2b67c2ab217a4df60665005b7bf7682ede79bde"
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
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end

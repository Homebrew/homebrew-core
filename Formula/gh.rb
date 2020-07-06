class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.10.1.tar.gz"
  sha256 "5265f9594cca6c4c2f0d573c810f4ddb16e3baed0c18b18a353529506fc41297"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "210cce26348d4b91860f6fd9cf2037d6f316474bd318ecf58bc2923037c9b456" => :catalina
    sha256 "1b56352a37dc5e336a93602cd0db37c58b8a8dfdec3e56d5bce8f4ff435f4ad4" => :mojave
    sha256 "fcaab84b4e5a4e08d045348b42bd431412a169d6d117ed7af76f483970b2ebc2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/cli/cli/command.Version=#{version}
      -X github.com/cli/cli/command.BuildDate=#{Date.today}
      -s -w
    ]
    system "make", "bin/gh", "manpages", "LDFLAGS=#{ldflags.join(" ")}"
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

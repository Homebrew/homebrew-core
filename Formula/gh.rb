class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.10.0.tar.gz"
  sha256 "5d7474a89cd0d284387f1b58dc8b1771ebae8fc83cfa2410b354435b295c07df"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f3207fc10b3f11c3821817bfeaec688b7dbffa3b7e5cb46bba58516c119d098" => :catalina
    sha256 "2ef36b969325e2a4ff5bff3e726f0aca62744e708b92d861e07f9ce8905302ac" => :mojave
    sha256 "f03c5689148154498bc5fb3267b839bdce5a6a7803187df7b2eb84b65838d610" => :high_sierra
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

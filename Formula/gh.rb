class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.8.0.tar.gz"
  sha256 "6439f2b01681be33b2b3fa313abdb700e5f6344ddff5e0fe8e01226c20d36442"

  bottle do
    cellar :any_skip_relocation
    sha256 "72455290a218359b87f061f059a03d0aa597fc6dfd380d5a4d9230b1bd32032c" => :catalina
    sha256 "b59b2944887b847068136757005b53e25f21a02d93d6366137704990b2cb2d4b" => :mojave
    sha256 "93fd06ac250de37b99cbf885cccb564d2988a4641d935435b5c99ab85c8bc9dd" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/cli/cli/command.Version=#{version}
      -X github.com/cli/cli/command.BuildDate=#{Date.today}
      -s -w
    ]
    system "go", "build", "-trimpath", "-ldflags", ldflags.join(" "), "-o", bin/name, "./cmd/gh"

    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues.", shell_output("#{bin}/gh issue 2>&1", 1)
    assert_match "Work with GitHub pull requests.", shell_output("#{bin}/gh pr 2>&1", 1)
  end
end

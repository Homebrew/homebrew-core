class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.6.4.tar.gz"
  sha256 "7dbe61da02c8fed6412ed6a3f5ed6163c495275f6e61236f51a27ccb052acf41"

  bottle do
    cellar :any_skip_relocation
    sha256 "33417664e363fa336c107319090d28d525a5927eff2da3c2a196f3bb75c3b310" => :catalina
    sha256 "77bfce132108d4e3e316841708404d54edaf198a476f89186da9b03152569bea" => :mojave
    sha256 "7e886674999f5be457fee81a231ccba5466121922f6453f2216df24bda9c897b" => :high_sierra
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

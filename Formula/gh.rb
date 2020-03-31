class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.6.3.tar.gz"
  sha256 "22d990ff795ff271bc626dcec424551853b095e5810e700531cda337daaa8b1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "81c94cb5014ae11533870e7365a1998169b8bac194a8cbf361e099f88c8705df" => :catalina
    sha256 "aea3c4e516c841ef22c0eeec953630053d7a41d7c677df1cf36ca8fece7745b7" => :mojave
    sha256 "aaec5682ae613f2ad4ef2714eeeb65e1d4d6252974ed8d7b861c82fc7fd849f3" => :high_sierra
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

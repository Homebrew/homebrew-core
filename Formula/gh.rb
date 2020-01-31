class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.5.2.tar.gz"
  sha256 "bdd7c8681b711d0d1d4dc027c06ab88e89d2f43af40eba6865cad52ee460bec9"

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
    assert_match "Work with GitHub issues.", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests.", shell_output("#{bin}/gh pr 2>&1")
  end
end

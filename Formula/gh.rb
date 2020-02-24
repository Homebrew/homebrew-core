class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.5.7.tar.gz"
  sha256 "a1185de36b27bb9831a172b70e60f741aeaa774682f3ac4bccb9df45734f8b5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3bda982ec4be71d7f414196b39dd8cb1cd711734033ffe20eda56bcd5e185cb" => :catalina
    sha256 "bf2969b3310e9a8f679f10f9b983e1c98146b88c453943cfb242e05c0952f0cf" => :mojave
    sha256 "9f81e80da8f47d7f833481e8ac45c6f2adf3d32f838dbf86c9d271e3bca1a244" => :high_sierra
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

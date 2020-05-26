class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.9.0.tar.gz"
  sha256 "318295e5a662f785662751f1e2cd4b1f613ec3aced1c4e7f1755d27922dbfdbf"

  bottle do
    cellar :any_skip_relocation
    sha256 "572150e8133f195e9c1ec6c1a76454075e60288959df8640d7b90b784a9a6a96" => :catalina
    sha256 "3858f26d0911724f57ab70ebd7aa92ffeff66f01d6a9ffcb87300a39faca4c94" => :mojave
    sha256 "21207ad29d1b31ec855c5b84125eee859c8ed616730b6408a1877e1b6c7135e5" => :high_sierra
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

class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.6.1.tar.gz"
  sha256 "237b18f9e3c82caa1cb06df3ca763ad7b32dab7e9a9a6f89afe7593bc31c3290"

  bottle do
    cellar :any_skip_relocation
    sha256 "43ea6eec675272147fb2a870538165d79bcf4326bf49bc51276fe55fb669635a" => :catalina
    sha256 "03f8a450666c935927c30d879365d8afa4af0c02d40721e9b58d2fe441588fdf" => :mojave
    sha256 "527b29a418c18ba7a04756c875487161050dab34b8c40bcc1379f8b9a90d808b" => :high_sierra
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

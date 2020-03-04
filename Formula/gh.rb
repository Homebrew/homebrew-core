class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.6.1.tar.gz"
  sha256 "237b18f9e3c82caa1cb06df3ca763ad7b32dab7e9a9a6f89afe7593bc31c3290"

  bottle do
    cellar :any_skip_relocation
    sha256 "3377a2056b55e814ec3c29766c8b3b5f8d73a1b1e50e346abe9f108fd20a7588" => :catalina
    sha256 "71a1f9df0a0c0623f0bcd0e735d3c985557ab5ba23c3935eaa3d0c5780c78e16" => :mojave
    sha256 "8da4d646a5f73564f842a8638c88b7e1a9c98b38970015f22cee3b78d898643a" => :high_sierra
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

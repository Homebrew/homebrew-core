class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.7.0.tar.gz"
  sha256 "c8966ee2c9fe8138ae7773c66b9a85dd2bfbffc7ca26ce189b294ae0b3e4c05c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0fbd53a580d32c326f1e3a17410446e2b5f265adfad77f7e2b06c4c93781e60" => :catalina
    sha256 "34b836aea96868c452aeb32a7d1ad447807eae8d21294ba9fc901f662fd6f698" => :mojave
    sha256 "821d0d7d77e6464e7fb2377600fc94a94103811caaf599ef410df8049ec82070" => :high_sierra
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

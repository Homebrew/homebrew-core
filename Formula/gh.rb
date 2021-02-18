class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.6.1.tar.gz"
  sha256 "b942d4daef4250de5b996871be09214309963de64f9513c8f0b039ced99f2950"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a0c6e8ab02ac8f8a520738e670353f1d61d972b89bc96e23f2371765b4c9c67"
    sha256 cellar: :any_skip_relocation, big_sur:       "f91ab9482d48171d150ebca0b52f82e01aaafe4a543c7a77900d4481ad1d9e61"
    sha256 cellar: :any_skip_relocation, catalina:      "a8353f58bcc3e84863432713a60840fc44f014d4af6e623cb3247e6fbae4a709"
    sha256 cellar: :any_skip_relocation, mojave:        "9d453f1df91ec5f72193e0f65e9131e6f0f3e5a7d5b37a1200e70e172641561f"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
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

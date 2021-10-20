class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.1.0.tar.gz"
  sha256 "4b353b121a0f3ddf5046f0a1ae719a0539e0cddef27cc78a1b33ad7d1d22c007"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c8a4aa91eb91928477e578168a32866098bd9d4dbca17caf39cf1b921925039"
    sha256 cellar: :any_skip_relocation, big_sur:       "62c1fa920d386d9cf5893643830319abad097e39d798e966c102c64a79f2b859"
    sha256 cellar: :any_skip_relocation, catalina:      "002847accc5930067182092649b6976cbbae09e84c70d9389f25bde1b9dd2ff3"
    sha256 cellar: :any_skip_relocation, mojave:        "242f3cdea693b1f5eb0896120367d9c2db1051b8b475ae48571f9479bba066ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0df8a2a2e73cedb7775e4c2b38edf81ff28424e708812b1c471179723c82b08e"
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

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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f19f7f06fc412ebd238dcda222bb35252c7f73e12287a1b5b5fc19ee1856d6d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd7378de70e3ca310179e9a81b80767902f35bd610d060010bf2a604d2e18598"
    sha256 cellar: :any_skip_relocation, catalina:      "28c1db589fe531a296f95918122a4fe89fb3724386148fd96104a9423c3abedb"
    sha256 cellar: :any_skip_relocation, mojave:        "0d72614c0db518bc16fb02e1165ac454501e7b576a7029ef383854ec9aa44931"
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

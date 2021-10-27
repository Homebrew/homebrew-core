class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.2.0.tar.gz"
  sha256 "597c6c1cde4484164e9320af0481e33cfad2330a02315b4c841bdc5b7543caec"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f21b45d9ecc03948053f1d0e50114a13f4439e669ac72358d419888a4feacecc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4bb54f147bb3f15abed9296141b9566f8215e11a02e147bd201003cec0a8055"
    sha256 cellar: :any_skip_relocation, monterey:       "c545de63ab831cf9e27e4118143e88249c324856f30d80c2b6b85d636145a79b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbb6999034c88aa685f191cf3bef89f64f7d12ab8a30210d0f784115f4da63cf"
    sha256 cellar: :any_skip_relocation, catalina:       "20c50a415ebe0678bc8b51738282a5bc86fb6df4927462466b03b2e8c256fb94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94e86f5db6d884e1f88741245c60587a4503c4326b0163ce2eefac0ffb4f80d6"
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

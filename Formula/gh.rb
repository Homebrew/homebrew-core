class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.12.1.tar.gz"
  sha256 "d37a96d3b12c489458e5c35ddbdeacac133c766ee50580aee4657eb9ad185380"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4b174492f878bdd729c619b0780deb591702d6e450702ceab2f720374d44907"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e246aad61412bd34babe6db7e8e97b4ce54ca98897d3c3a335272fcf6bd746a"
    sha256 cellar: :any_skip_relocation, monterey:       "4bf0e7a891a876f51e32cfefacdcf2154c7f8b78368343c1bb0198678b53ac34"
    sha256 cellar: :any_skip_relocation, big_sur:        "21b11cd4f0e5cd73c980a76d63e0a108b2442ac392c41812863a59dfd52680f4"
    sha256 cellar: :any_skip_relocation, catalina:       "b91ab6e333820183a3fc500d69c4dff83828d16473a09f64960d4a1d41464e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33cc7568a5c36d2d1a313cb88c8c16ff228ddcdb1bd86f408302140817c48708"
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

class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.14.3.tar.gz"
  sha256 "b674f04ff9954564ba74488fc22817f5548bcddb5d9d582720d2421604988270"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e320e0062ce98af816dfdf5325801a452d2c875f3d5e8287a9fcfefb4410d6e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42cd9afa5e97b83bec6073bb080f0219007ac74ce3bc316c9399c92415515370"
    sha256 cellar: :any_skip_relocation, monterey:       "cf80fe4528c6c962449146a7e0780b073a118da29746971c817bb4f1b41c60bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfa696296d9cf897b68b5da8a8742e4de636b9cebb768ce2a296d1aec01fba25"
    sha256 cellar: :any_skip_relocation, catalina:       "0b573cdc34455e56549a59aaa767f6fde008e134ca0d1b3396368ef479afa535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0747a6be7f1444f01dca53f18a3c3a5f7d12a3be9045c8b6ae84e4c557ba31c0"
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

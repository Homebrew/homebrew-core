class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.12.0.tar.gz"
  sha256 "e231636aa516802500107726fdcca8c3290db4d8efb20451b0b2008e9e83d4ce"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1abb60255fd62bbf84cb73582210f8f9baa4beb0a5b25bd2d1ddb523f9be89e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70be9ee6ecf7f251e74fca6bc472083507e9fe235b284e9fcfd0a17cf36dc546"
    sha256 cellar: :any_skip_relocation, monterey:       "e78175df11f4ba504638319c2d1e05dd617f89099bcb6403469126a5cb38c2b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e1a64ef2fa3dac19734655c0c230ce3e3f5eec54fa71a07b98ddb6b02025f50"
    sha256 cellar: :any_skip_relocation, catalina:       "3f181da4d2ee81965cccd8ab768275ed7a1dc5564710da9f7381d6f31aabedfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7101d6db2033245f1141b73b8a0d10b8acf424451392f4773af350a049959e30"
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

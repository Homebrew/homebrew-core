class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "668564086dcf51acbacdf30103cc916cbaeac8be8e80bad3a96e388dac1bd360"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60639e974d42269ec19422e26f413ff755b034389d0ad249bdcb8deeaed8df3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60639e974d42269ec19422e26f413ff755b034389d0ad249bdcb8deeaed8df3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60639e974d42269ec19422e26f413ff755b034389d0ad249bdcb8deeaed8df3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "130823f031dac5581ae1960e278baf389efb66455509e7c30dceb7464bd7c629"
    sha256 cellar: :any_skip_relocation, ventura:       "130823f031dac5581ae1960e278baf389efb66455509e7c30dceb7464bd7c629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa81e12b9428e99281c043b6833b53a88e5800d25d0cec17f779f04e2e97b0c6"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gs")

    generate_completions_from_executable(bin/"gs", "shell", "completion")
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}/gs log long 2>&1")

    output = shell_output("#{bin}/gs branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}/gs --version")
  end
end

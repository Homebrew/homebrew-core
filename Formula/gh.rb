class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.34.0.tar.gz"
  sha256 "d872d2e9a934aefce0e9873033fee3aa160a6079af73598b7f8d04c4a3d15a7e"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "024f6bb8677ee250a3e8c3c3f3e9b8d7c10ac30c23ea4a85e73c0a4c705a0d95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "024f6bb8677ee250a3e8c3c3f3e9b8d7c10ac30c23ea4a85e73c0a4c705a0d95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "024f6bb8677ee250a3e8c3c3f3e9b8d7c10ac30c23ea4a85e73c0a4c705a0d95"
    sha256 cellar: :any_skip_relocation, ventura:        "6f42c4c66d68ca1bf3c0fad542ff092ee9cdf3a9e43d743125eeec63d1afc01f"
    sha256 cellar: :any_skip_relocation, monterey:       "6f42c4c66d68ca1bf3c0fad542ff092ee9cdf3a9e43d743125eeec63d1afc01f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f42c4c66d68ca1bf3c0fad542ff092ee9cdf3a9e43d743125eeec63d1afc01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29e28fa5e58200be7ec206ded0b7a4f3b0296fb0a14da2c41c8b3e2216366617"
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
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end

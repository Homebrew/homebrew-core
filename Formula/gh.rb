class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.30.0.tar.gz"
  sha256 "5e66be97f51559dcea3621c8cc3cf2f67bf47bf2e1902014b3ec5689ab4e8add"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a761d6cd81fd69ec2e94e6e27a12a08399b468fd82da91367bcaeb13796c00f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a761d6cd81fd69ec2e94e6e27a12a08399b468fd82da91367bcaeb13796c00f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a761d6cd81fd69ec2e94e6e27a12a08399b468fd82da91367bcaeb13796c00f"
    sha256 cellar: :any_skip_relocation, ventura:        "abb26c8452d28bda18bf70174b8fa2e0a71e8557518c01f57c98d6d9b0c9579e"
    sha256 cellar: :any_skip_relocation, monterey:       "abb26c8452d28bda18bf70174b8fa2e0a71e8557518c01f57c98d6d9b0c9579e"
    sha256 cellar: :any_skip_relocation, big_sur:        "abb26c8452d28bda18bf70174b8fa2e0a71e8557518c01f57c98d6d9b0c9579e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdf508847a2ddd2c99836a9ae6d3365e9022162c80a1a37efc99b14703fd6be1"
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

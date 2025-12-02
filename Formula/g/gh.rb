class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.83.1.tar.gz"
  sha256 "5053825b631fa240bba1bfdb3de6ac2c7af5e3c7884b755a6a5764994d02f999"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d37c496644cf8ee251e451b46ab6a517d17c316e723bd0fd73e065587c8a2a4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d37c496644cf8ee251e451b46ab6a517d17c316e723bd0fd73e065587c8a2a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d37c496644cf8ee251e451b46ab6a517d17c316e723bd0fd73e065587c8a2a4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3111d1c388d4f8574c6fc78dedd015ed091e3503119f891ba3777415e938701f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fc552a4859ae88829ae79a8f3c97b66040e6a82e410da08166968b997ab9d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abe8930389df52d31914d41d478d9d193044544ba5bad7c0f02e63c17a3b3005"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    ldflags = %w[-s -w]

    with_env(
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => ldflags.join(" "),
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install buildpath.glob("share/man/man1/gh*.1")
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end

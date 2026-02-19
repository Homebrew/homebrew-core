class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.87.0.tar.gz"
  sha256 "c4ac248d322c6b55d02d1a53fed755e69161a6b816f72e400fe3ad593743acf4"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ae4f70a3109c4a5133b536e9d554a7ebe1966bafabad7d4f0db37bb2c95e224"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a92beec557aec4a5b6614bc6845abe8e33902685665a0eeb257f5cfab04e3178"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ea5d397ac32aec015d7afa3e996bdd2dbfe45e86f88e2320e58e66b5b407495"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e8d80c1d7171478b7d9c2549f4d528c56d8477c02dbe3c19d2adfb5d116ab30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35744a8015d83403ea1e80088f5d52c2efc6d26990d243c569b8b8a420041742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d2c5c42d6f5a40f195bb884095a62723a8620fcfb24fd7498ab75382c1d7ffc"
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

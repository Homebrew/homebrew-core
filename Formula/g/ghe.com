class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.82.1.tar.gz"
  sha256 "999bdea5c8baf3d03fe0314127c2c393d6c0f7a504a573ad0c107072973af973"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9695cb8604ad36f9d8b4c2cda5cefb231337728faebf83224563991c3834999b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9695cb8604ad36f9d8b4c2cda5cefb231337728faebf83224563991c3834999b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9695cb8604ad36f9d8b4c2cda5cefb231337728faebf83224563991c3834999b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f766fe6bd74b16d6cc3e839d6283b86d903b2d73799f4cc8ee4b9a56d35c4898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd70bca2a11e036713de28910edc9e3c858d6bf9716bfa6cda1e730be5cf6636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7244d94a6b2d25c79605e93652debae4deddec009755194411a698f00a79ecb"
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

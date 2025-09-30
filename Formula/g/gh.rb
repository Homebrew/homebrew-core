class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.80.0.tar.gz"
  sha256 "fd9a1fc392b10f99e9f6be287b696b8dbd1d1a14d71ccee1d1da52be3f1edd6e"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "386d6802edc9890f30d60ecbda5d92ae21bc5a3538c4f234b53face169b3fdc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "386d6802edc9890f30d60ecbda5d92ae21bc5a3538c4f234b53face169b3fdc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "386d6802edc9890f30d60ecbda5d92ae21bc5a3538c4f234b53face169b3fdc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4cd1ff6451d098d3e7f55a1dab64a9ee4d41f10a338e5a831d83bc16a119b7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4572f11c174aca1758d6a8aedbe3529b949ab42831d896b372d2eefb28e4eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4454804aaa5a116e870f5c853047c4e4aa1e6a0aff7934ff55c98d0a525430f"
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

    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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

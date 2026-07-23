class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.96.0.tar.gz"
  sha256 "8d80d0aeccea7bec8024f8c30365bbfa76852901f2b2cb0afb7ab2cbf6d317c2"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "369252b0146cc9faa946302de4bfae00b0645f50e36e569d0525408a0d4b0109"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4b1479c74f7be13c6cfcf8a3f1b77c6e8ca39024379f1ac24735e0a02fa6ced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c943ce8103fd9dda9fa68506230e0d380af6d2b778d551c4d5c69e611a077bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "cba3459a1f8234f9dd3ebdb8cad006b2c596496c14235f35b41c489d450603a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4150ed93a34c763d4486228fec0702db013865e1b533e557c2c089e7af905a80"
    sha256 cellar: :any,                 x86_64_linux:  "55203262171903398fa5d36f4626100928f58bd74a0c7932b5cc19e0c1bf3ef3"
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

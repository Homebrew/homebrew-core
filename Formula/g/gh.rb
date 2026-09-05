class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.100.0.tar.gz"
  sha256 "39d5123f08a553a6fa69e46de86c22d04d97a217e03d0e6584b66d0fea50f1fe"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e98510bc683db27f42ff84c9c7f5b884e3109f499c08241991617031bd63666"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deaa10d8960ecefb3008008a3d881120aee18f1c0c0301fd6fce5f570289ec58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccb93acb03870be8f4fd361de031631225c848552aa3c60c5f292e199b2f4644"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f46ca3e63fe494c6d5cce5357cbaceb57b1f195e77cce19e630e78d62b79ee"
    sha256 cellar: :any,                 x86_64_linux:  "fc13b7681c5eab78725e8ed13a9cd032a9a9dca849c9b04fcf9278627a0c557b"
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
    ENV.prepend_path "PATH", buildpath/"bin"

    with_env(
      "GH_VERSION"   => gh_version,
      "GOBIN"        => buildpath/"bin",
      "GO_LDFLAGS"   => ldflags.join(" "),
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "licenses"
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
    assert_match "GitHub CLI third-party dependencies", shell_output("#{bin}/gh licenses")
  end
end

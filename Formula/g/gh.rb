class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.102.1.tar.gz"
  sha256 "6a6959d4da3302d95812d8ba1a96ffb3e21874badb0dc25f2819184c372157fd"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6eb60d50f7c4aa7e4f1ce0ad6eb57c4c23b4b8575cc1442156edaf2139074fc9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "556c722ad1a21ff58a1ada7de08074e88d5ca54042c63b9c8e8d16c1a341fc05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e295329cf4743532eab40341b44f56b03ea415d13c80bc929604d8bfcb2a8797"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c477e22cd8efa575dbd10ee8522d76d3fc4ff5409522354314de8877ca770e74"
    sha256 cellar: :any,                 x86_64_linux:      "6de32c7714a5b09f4eaa40b5fc4b6ae1859000b407ca10deef36ff39e1141c1c"
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

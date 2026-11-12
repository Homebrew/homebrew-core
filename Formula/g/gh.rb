class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.104.0.tar.gz"
  sha256 "779060cbdc5a354fa2fc8afb56e9277f64a29ac599daefd941558356509081e4"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "79a3bd83186260171c42ce1c293b0e908ef5550fb85a0ca7664ae2adb084d4a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d7f56223b140e5c6c4c81b86c677451625fbbd5ff1a091696459801d98e64b94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "65078fd20ee498601a0d1c3d61e567ed5cbdefbc92fc6d382c3da6d157698437"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "748eecf9cf7ba449dcc7ed220bef2411a360746b6c10e566dfe9ce9bd6746fc1"
    sha256 cellar: :any,                 x86_64_linux:      "ec317ad43eedbf4e0cdb37887bd925c4e8ad6d99c04cc8e13ff9e3d016e383ad"
  end

  depends_on "go" => :build

  allow_network_access! :build

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

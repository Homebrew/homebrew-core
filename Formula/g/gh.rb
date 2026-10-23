class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.103.1.tar.gz"
  sha256 "590a1fd4d9ba8e678ab5aef41c52dc1adff69379cb82cdbb7ee7a64ac33f2d04"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0de13f9d4241eb568583a8a8888c557cae04e92828ebf134196cc3b9bdb2c30c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "330396a45aef280bbcca0614f174cf3f409432190e7c7350c5f0070ad4037eca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8eb5f3f049848c33f170c2d52b167824d3a09284ee1b69f03b27a8512c8f4d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "692868cbe250f7e402fe90d5f1d622e71fb2891152ef19269a6b27d310e5dcc7"
    sha256 cellar: :any,                 x86_64_linux:      "d4ab8708f78704a6f590eb3f4a4f4071530043b41a8f83953fc53250d1c13055"
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

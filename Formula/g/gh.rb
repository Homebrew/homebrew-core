class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.103.3.tar.gz"
  sha256 "bb148138a3a2fe023e57c78042fe3b42fc09171c0e8fff4cf983b227b7a2eade"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a6c3b09eca8a065522c78d3c2ba739e866afd64eb2b0a6280527b05e5539151"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "901fc52c4611b1c716ed73b31d516d6bb6b37bcfb8abbedc537404bc80ec5e26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21e6314bf4f4f9d881b0ab6ba1f6bad3c940ab419f8b689f83a526eb646291f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2bf1cf7e6aa89f23f14a55646d70434e3014f68b72d53e67ac710a1b9269e1ca"
    sha256 cellar: :any,                 x86_64_linux:      "bc13ea369179fe336f14316c11e4cddd020a84aa17e9113508ef5b43a475eefe"
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

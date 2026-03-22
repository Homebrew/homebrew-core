class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.88.1.tar.gz"
  sha256 "79b9d8b6f45771188bcbe7de23e0300827b33454b811881522e20f6b48bb6e4c"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab40e491b2aa6c3aa3ca1cf671ed90daab5ad452a8c7429dee31386a5b0679db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d34075367aebf00d5d949b38079f74363d22644840aa505b8481add7231f607b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfaf3adfea25cd508776ef593ba9b642cf7c1dac856dcc5052c49e62982e3234"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b55b9f8e78c2230c1bb17bf8af2c39e98e6cb19e35d1e1e4ff71c5f3a5ed4a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "122f7654d77fd1752120488bcdd3217b0e7e55d8aeed378691a4b1f20c09b10e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ece9cbb70e72be644b721c604a873579ccdc96d2c5e0924a2108cba93e78c31"
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

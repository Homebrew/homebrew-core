class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.105.0.tar.gz"
  sha256 "3a8fddd2ca0f7c96983a251d3971a84ef042b230b26ca696e5e6ed811cd0ed8d"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "04e000cb2faa577e8b164c46479b1d517fe6777c1bb3565fce42293103a68f0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37b15d760c279e04215c5a6ec2b43e7a2cb2fc5b60158b58c2658ac81af90b9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "86e614f29b06c2262f756074566bf5ef765040d7c2d3fce6523a392a8a45eee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "610606cc633a32264669b38a875bdeeca21786dabe2f30096ecdb1dee41f1045"
    sha256 cellar: :any,                 x86_64_linux:      "ee2e9739e1ed73652cae5e684a60842c841afb09324ab1ef22f0aef5776a8660"
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

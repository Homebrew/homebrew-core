class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.95.0.tar.gz"
  sha256 "b6a1c88cbd15f49f60a68d210a117a60b349bcb0d028a0dca0ef2d9dc92bd028"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b124594105ed7619f64f34ae8b85fe9e09b22a1a788c13fc81bb98d03b81b255"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a3e4bef34be78b518a9acd23588985a3736b4f1a81b66b9f221a70ceaf3fccf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7734574d0dc55dd79d3666819b433e1f3a4471755d4bfa9b1accaeecd1d555b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e87ad38891e466431c30ae4af0aedaf79c3a88981b9bcfbdeb708c4d4d48ff7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c288bc5d09ce9d0ef63f0248dfc0110dbaf745649d1a0b09ed1e0d16aba8145"
    sha256 cellar: :any,                 x86_64_linux:  "38dad566289ecfd555bdcc90cba84a656234787fd9db82a2d598cea40995f6a5"
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

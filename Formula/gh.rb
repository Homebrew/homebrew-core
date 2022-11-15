class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.20.1.tar.gz"
  sha256 "bd65dc1855616823003f79fe1deaea77dca420d7c465bfbb13b5567876219d8b"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b139f0540beb929e9203370e6a09e782d6c03431fcd3cdd4ce2938b63f8ba471"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d825d65f18830c3fe0ef11a47c3381a16d3ad8add872abab92de667dfb8d093"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d31f8a71350f9cf12af7fad3d7eb7abdbc7cd6baa6e6f06f9ba3795ab83eb7e"
    sha256 cellar: :any_skip_relocation, ventura:        "f93172cc35faff461ca93757e464cdcb963a7c93ada5c4e573bfff0ef45b2384"
    sha256 cellar: :any_skip_relocation, monterey:       "0f247f159f7f5fe92c2ac50f79f58b8db0cab700e559e0f58bdac98cfff125e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bddfe15b91c862434c3eff4ce7003c6bff6260b7d923fd460cfc1a858942b738"
    sha256 cellar: :any_skip_relocation, catalina:       "539ba00e04960b7c7ac72357d4d164af8aecb88a363fcbfc17b34186529de782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eca62f7c33280a9c094b75becec4724d2ca958d126c6be9482e238daf91a8cda"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end

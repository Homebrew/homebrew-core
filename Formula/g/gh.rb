class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.71.2.tar.gz"
  sha256 "f63adebce6e555005674b46ea6d96843b5e870bdb698759834276a69a121875c"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15f7543ac87facf0a345addc7227444fc9cda6a09906eb3c4d21828f1c4ece89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15f7543ac87facf0a345addc7227444fc9cda6a09906eb3c4d21828f1c4ece89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15f7543ac87facf0a345addc7227444fc9cda6a09906eb3c4d21828f1c4ece89"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6be5d3650f9f941a1639ec1d1b88fb59db61f7911613a60e42b642e14940f46"
    sha256 cellar: :any_skip_relocation, ventura:       "da06b10abd0ad76f5432fef1182739c305f06dcbcc7a9b36862ce8249288c43c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cad2ff75cdfab4c59784f88de923fec5eed212d305a09ace84ddaa19605c6fd2"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    with_env(
      "GH_VERSION" => gh_version,
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

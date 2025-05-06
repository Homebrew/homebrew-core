class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.72.0.tar.gz"
  sha256 "5a2cd4f2601d254d11a55dab463849ccccb5fa4bdcaa72b792ea9c3bf8c67d23"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d410ae1b49862ac691753deccfcd7167da4e9a88466c01e17e1e8fddd1bff6ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d410ae1b49862ac691753deccfcd7167da4e9a88466c01e17e1e8fddd1bff6ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d410ae1b49862ac691753deccfcd7167da4e9a88466c01e17e1e8fddd1bff6ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e54cf664dcc6e4493a9bf50e12946adfa8242734792620a9b9c1c7df7275c36"
    sha256 cellar: :any_skip_relocation, ventura:       "46d113ea2cfb36f3980e98f21acf8f97fbf0c4ded57946e3ae4bb7247088975b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df94de12df3c9d99fd0608fad282f5efae282323b8b19eda0bbcea2eff8e5ff7"
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

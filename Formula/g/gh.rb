class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.69.0.tar.gz"
  sha256 "e2deb3759bbe4da8ad4f071ca604fda5c2fc803fef8b3b89896013e4b1c1fe65"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7b1fb2a0267f7a2fb91c4f5089484e9131b9ac11dd168cb752d59727953f493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7b1fb2a0267f7a2fb91c4f5089484e9131b9ac11dd168cb752d59727953f493"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7b1fb2a0267f7a2fb91c4f5089484e9131b9ac11dd168cb752d59727953f493"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa87fa2641f00140589ae7e0988564356b0c54d090acb3f8435bea89a17aa1e7"
    sha256 cellar: :any_skip_relocation, ventura:       "d185a7cbeb3e722e3e5cd8ef0c5e7784e6af6f6385a727038466ca03d9d31837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "195f5d36b4906ae15a465b14e08f8eaa09c37767c541f91db306ee4c6f11d423"
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

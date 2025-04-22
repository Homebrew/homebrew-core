class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.70.0.tar.gz"
  sha256 "9e2247e5b31131fd4ac63916b9483a065fcfb861ebb93588cf2ff42952ae08c5"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3117b56156735add453530949c54716d2a929531ebf403348f5cc308d88890a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3117b56156735add453530949c54716d2a929531ebf403348f5cc308d88890a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3117b56156735add453530949c54716d2a929531ebf403348f5cc308d88890a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6262faa6ce8fd90ec215963c636141a2cd89b5985a234e7b2d54a12c34954c1"
    sha256 cellar: :any_skip_relocation, ventura:       "e78e2880a7fd885a82a10924e96f05c5782f29aa093008554deb1d1e67cbb4da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3092c6da3b914ee22327d2f3c7ac0216138e506293fa53c55d7689d0663f2e4d"
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

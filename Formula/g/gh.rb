class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.74.0.tar.gz"
  sha256 "b13e60f114388cbc20ba410d57b43f262814dec7d3e37363accfd525c6885d3b"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fe2f192935bc17640db32dac2af838aae1f1fa8d34adca07db4274bd4bbf3d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fe2f192935bc17640db32dac2af838aae1f1fa8d34adca07db4274bd4bbf3d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fe2f192935bc17640db32dac2af838aae1f1fa8d34adca07db4274bd4bbf3d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "984fd93ecf2dc65a508e5aa614ebd75e53f286c0cff4ff7203cd128cfdf853a2"
    sha256 cellar: :any_skip_relocation, ventura:       "702f6fb14e9e3db15d9cee9af66e0342605334305f0cda7f66dad5bb33e143d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "850479fcc72eeec97eb7d7a74d79dfedad2f3c62d5b45a37beae63b2b1b57910"
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
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => "-s -w",
      "GO_BUILDTAGS" => "updateable",
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

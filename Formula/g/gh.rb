class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.92.0.tar.gz"
  sha256 "ad18928ce4e2695d7fc1adefa0f5e0496e570a430016cee4c22d7bf87e5d9c1d"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4eb5c69f4666a1cac19d67ecf870389c76257130db90075c870587f1afcec75a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3192c6e260a00cae347ce9d1e16f3a5680f9adfbf03f6046e92ebd08add93e44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b2c23c140b798061e5cadbfcc26d7333537db438e53aa7b05461948382ca147"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4499c7bf9b0505558bbe22785da6b5eae16c2340595c8355175a33d3e57916f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8874100fb84540e05574fb4d46851b01411fb0db891591bc5cf8dc96f980e7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58e6d1574edb2524749a4c4c35cff610a696a3b2cf0a8c1ba8903adf1ecb1e38"
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

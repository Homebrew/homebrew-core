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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "785f22aef70e2da36c2af80114681078f8b45d09c61ba359c9e5276860417571"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2081dc6dfe108cb28dbb9aa24887a16f9d539acc223fbe8b982e387f5c8d846"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b56d4590d3db25eea0fdad0e782b082051b3d0450525cb1aac5261a2313528d"
    sha256 cellar: :any_skip_relocation, monterey:       "51c61ba76236526b84f3c87c0e16ee72fc6eab50c639657fd6b5756b5b12e144"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fbfc3fdce1cbe1434237371b7bd58a460e47cd582b6b09df98a35622d562823"
    sha256 cellar: :any_skip_relocation, catalina:       "2a8327d05d50d9ca28d5a8d4b5a06e5b90a8b3408cc0a9f774b38b61e22b560c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a9dda6f66bc965f498bcdafc439a5d36e38d389bd78cf966ac69e3b451e78e"
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

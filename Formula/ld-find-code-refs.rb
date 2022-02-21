class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/2.5.4.tar.gz"
  sha256 "64865e18fbe2e447ed83d920b3ca8dedbb09acb6e8afcbe4e4921f6ea2c234d2"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93973114384497b3515ce15e5751516ba7c9bd0a23ceddf3f09b9a6f5b27f2ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5abd70486e309038b30c0d769587e5091ba03ea20567f63aff31505c9f226d7e"
    sha256 cellar: :any_skip_relocation, monterey:       "f22aa5a23d96797ec726789afb9225a219e66e03e0778c5bcce9eb7a262f80ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2d6f62d56df3e274a34dbcc257080f66c39ae166234cb2eacc1914f9e91d0d1"
    sha256 cellar: :any_skip_relocation, catalina:       "77b59203c895144a467a0cf2cdfd1d3888ff1e63c7b6c258e8ee0cf501c3a84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f20cfa05ab4b501da7fe413564461ea6b3c38a0eb8bca838971be24f197831"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ld-find-code-refs"
  end

  test do
    system "git", "init"
    (testpath/"README").write "Testing"
    (testpath/".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"

    assert_match "git branch: master",
      shell_output(bin/"ld-find-code-refs --dryRun --ignoreServiceErrors -t=xx -p=test -r=test -d=.")
  end
end

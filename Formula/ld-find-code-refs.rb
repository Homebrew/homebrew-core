class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.7.0.tar.gz"
  sha256 "4793197ded1d5747be765aab04d7c7f9fb47f94cad591cb778a9b1ef221b1ae0"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "553b165d00565448be8c0ff2e96e10255a4b0900d505eb0cb58a5b27541c5f63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c209bf972b479bad44b3bc4570f258b921260b057b2c5175620bdc83a1dbc943"
    sha256 cellar: :any_skip_relocation, monterey:       "2f82b931efa422b7773e4575cf2ecbf42842af8fc732681187823cad2dfaa0c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e83d13b4f0119694bbd89775e823293827fb7ab394714c24364c225f9019b03"
    sha256 cellar: :any_skip_relocation, catalina:       "1008eff3eb46872e1b77907c313c18906af3b958888f348861b844bc90ab52b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdf84d5cafb55a4737a20172b79ca39450adb26c1d1892c2b13598e2033a7406"
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

    assert_match "could not retrieve flag key",
      shell_output(bin/"ld-find-code-refs --dryRun " \
                       "--ignoreServiceErrors -t=xx -p=test -r=test -d=. 2>&1", 1)
  end
end

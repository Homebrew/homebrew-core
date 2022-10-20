class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.7.0.tar.gz"
  sha256 "4793197ded1d5747be765aab04d7c7f9fb47f94cad591cb778a9b1ef221b1ae0"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b526a20bcb70020df9a1a0f66780dba00d31a9116e96b9b536bcfcf60ecc34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36b394ecb6b61dea431555cec81d932fc1dcf16ad83df4dd5cf8666c5848de7f"
    sha256 cellar: :any_skip_relocation, monterey:       "9d36891ed87210745606499ae1f39406d3c0d2069e7ffe9d8576e516dc5c48c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "00b8a94e2788b63ad90ec567e758583727fb482ae9d882dd7005c9e07d48c9e1"
    sha256 cellar: :any_skip_relocation, catalina:       "81478b4bd007f2b92985146656494c272b491b347ab6877a5d2aa4c85a495cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "add9d4bd6a449549173762ac8199cd5ce06c1cbc118647b2f93ac1329572daec"
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

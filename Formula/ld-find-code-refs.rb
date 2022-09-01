class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.6.0.tar.gz"
  sha256 "d4e0d5c890f63522afc5fb8a753f9bba4c064e58407cf97a44e4cc3e2627e410"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54efb6ffc8af447377ff108e54492630ab29312d9e5c4494946a2fd669889fe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32613c22008da7f239f722ae4e5adb860ceb2f4779cd01c91de4e66eb3a8a55b"
    sha256 cellar: :any_skip_relocation, monterey:       "85bf24118970637f72e9c018986039441a0435ea4857560e9507acc39dc8342b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5c2766465167344bad5165cb4fe78070d03be584ea7b31699c0e38800220591"
    sha256 cellar: :any_skip_relocation, catalina:       "50ee0faf1617cd2644e1a287b89adbed09ff1fc3888d02eb55f2ddbcab6dea48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f694ace79ff71c3bfdf350c6bba0eebf4e8146cf7ea1bb1cbf2480119f5fe45"
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

class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.11.1.tar.gz"
  sha256 "031986e14e7fab5e075e295ffa0b11e294cac6d0c1e81597141586eabe3ea403"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1253f4a8bd57710dc0f92e9e0781bfb4c165056525e58185bef1dd2a894952f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e0fc171e8fcf8fee1f7c1bb596b0b6caec48024d5c8f7362e6bb683e1316cbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a504a735ff73766036d7b00c85da7b45596e21668a695760b84bc91ee8046928"
    sha256 cellar: :any_skip_relocation, ventura:        "22d7335c05f013341966ec5f864007178166145e6e4794306249c696db4663c8"
    sha256 cellar: :any_skip_relocation, monterey:       "21b6ce35750bfacd68506039a237d035335cd3fa5656d996093c5cf4ff3b41af"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb278e8329b138e2d3ca56e720634ce1e7367d51ee1413778820fccf58529b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f39a3164f72273b4b220c7936939bf4ade95a9c828c27b1315f72ac01442e67"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ld-find-code-refs"

    generate_completions_from_executable(bin/"ld-find-code-refs", "completion")
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

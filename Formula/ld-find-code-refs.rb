class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/2.5.0.tar.gz"
  sha256 "a58917277d7fa15367ffd3e74326b13c1371858ab1df9af4c61883bd8e5b0ec2"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b23bec45976ffaf80b1351a02e8059e207d8e63f37a5deaa46b45f60fee537f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a80469e7b9ea6604b1a148d9d1b6e006da67901441676d2916b8e7e682f47170"
    sha256 cellar: :any_skip_relocation, monterey:       "2dd7c86e3634cad302c609cccdbff4d3cfc17e7992d1a9cde7638bf38a9ca7e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2451a559af68f58111480e3bb282109e7b6c6e52b66a2dab443f8d8334903665"
    sha256 cellar: :any_skip_relocation, catalina:       "72ad39ef67542a4f7afc46d08416a0748b05a7dd1f72822daca74ebdd5105d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17c84bc9fc9f0d9c064b7b88425379b94ce6f8ce4033af4faf0b77c8cb9f43fa"
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

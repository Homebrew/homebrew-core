class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.11.2.tar.gz"
  sha256 "493b7b03025e2310c8b75fea65d40755984e33b87e6f279c3bdd23b78e270dcb"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8da8c916f4c1f17c9a0262d0590d389925f323c621520ce820ea5d1430a6b98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f30f3d5d392320e620b6bee8e3950263fba9b6a3d9bbd4ec0f1f9147c717d172"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db0fef6cddc6dffcf3da0425930b84a7a26f850c4bcaf869d03af4605701eabf"
    sha256 cellar: :any_skip_relocation, ventura:        "2bdfa7c56106b9b5abed12d09e9446854ee3b047ec342ed80585f3f5f0ed85c9"
    sha256 cellar: :any_skip_relocation, monterey:       "416bbcb7eacc078743b4bb1f7ba14461454f6e3b9f835f2c0aa622f243c10471"
    sha256 cellar: :any_skip_relocation, big_sur:        "0939cc5bb42decbfd5c5ed8c670d28b94304d26a05b87eb0629deb27b6b4d760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b75830e067d85082777d20ceeab98d21d58dd27f18272dc5ed71a1bc30907cb"
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

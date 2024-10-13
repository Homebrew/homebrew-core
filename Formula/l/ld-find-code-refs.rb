class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "8cca0cb5ac958ef9d94b8cf9349425d0ac151e251eb05b738503f83ef67289a7"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "be1630991230719e5d33a36d18b6e1b6f967ad97210ae1c84848bf64b055f740"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e8d9b7605ed6a5c0045a3eacba01de6762b78aa036c4366ad4c86fca6d2edc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15460e9fcca81bcbdfcc1db6ef07c3b3243bbbe4ef55ae730a3955135e0539f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b031d3f22ead9222ffde8c664b8575de669d176f1c596dcae2c020ca12c5764"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdeae6a3b24e5516eb65baed3875f037f057412896622ade7d6aa5ff2cac62f9"
    sha256 cellar: :any_skip_relocation, ventura:        "9071447884aacced4f0db5a4e7541e031f6ba01664f1a45fa489891ac1def587"
    sha256 cellar: :any_skip_relocation, monterey:       "bd864f54d94c9f1a8149d42fac037d990144261baaa3d8b5c03f51d9130bb091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2133f0a0022504a0d7771862b5a712805fa01c1d46b0f56856873853beda1bc2"
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

class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.11.10.tar.gz"
  sha256 "66bc925d05b6d7bbd9a5ddd3bc4b62f26d7797ef39d205be63906014bd7aab2d"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d285ffb8abe85b9057db1c04448c43014eeee7a3457288c1e7fdbe1cfa1a54c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cc1e755714e9a61d81c0f520d93aa0597f3434cf75203b330e7e067682d288e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c260beb34bbf255e5c74129e5938a3b69fd48e1bab667b0a935b764f9bd01cb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c55721450cada89f33ca78aee162c9145e0b1663e5459c6aefdc42a70665db5d"
    sha256 cellar: :any_skip_relocation, ventura:        "8f8471fff4d8fe569b580197b2c2feb0f830ca5a9854851337a215dc92be87e3"
    sha256 cellar: :any_skip_relocation, monterey:       "34c09f6e585eb011bf7b8abe28de1dd63557b335f9bcead9ad1153c2cce5a6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7890a5a9e2c6b86e12b887e662e8767bfb469e00310b14e96a9597d0d856ead1"
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

class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.5.7.tar.gz"
  sha256 "45f39b225616930091e1746c09520335dcf498fd9947f902a15074fbafe0637c"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90fdc70bdbe6432f20045f572cf4017765fe29c71d101b8f04292b75df71beba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00d91cc47f164b654048a3dfa16a4a14fa3d2d82023bb459860098dbdf1d65f7"
    sha256 cellar: :any_skip_relocation, monterey:       "af6cca9fe2a0bd30a2d53d9a7114f427768cb14b8728d2ac03bd051d62ff5ae4"
    sha256 cellar: :any_skip_relocation, big_sur:        "99e7ed5edb5ca5529651efced00d2232edef0ea0c8fdf7ae1c20d61aa0992be8"
    sha256 cellar: :any_skip_relocation, catalina:       "b41b5e63026e03bee46f2052ba2695aa1856e3299e97c2b264ee57875e24eeee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a9cd48278986c9461bd29f504d3dadda47339e778274c532c52e43c46719a20"
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

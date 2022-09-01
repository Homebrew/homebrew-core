class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.6.1.tar.gz"
  sha256 "55ae5bf53691007392f940ae6575c5be37bd9d131ea425e66740ccf5fb24e928"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f937afbbea914b382be20c2f53fc05ee34f65e87349c88fff1fafecf41c1f0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4e5ee566d067ccb7a86dce2b3f20f591ef6f9d3adec003a3e8a4de397dc9bba"
    sha256 cellar: :any_skip_relocation, monterey:       "e3ba8e56e49046e0893ee8d9f8f921e07b63be0353b75331455999f5b197a83e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cced99b03bd880e04cfb95b276be736efc40c10515049a696c3ef1de10858e6e"
    sha256 cellar: :any_skip_relocation, catalina:       "04aadbc6e02c39aac751025e3b2112e4763e3ba799a218c0d0fc3a2164b1725a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9f14d4a3b374b7c9c76f82098a9093dbd520d4c0652c1745929bf17416b5cbf"
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

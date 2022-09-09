class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.6.3.tar.gz"
  sha256 "d778dc9b80d42011a1b6ad55cf072d61528f0a35a10496f011bcefa3f5d83464"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "badb91b262f990919f4cea6de16b3e58c0d981f8937a5c5cff00953e9c0f03de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7469a1ec8a0a1732367b1bb968af7adb4577768e221db111f1ddd143acabd7c"
    sha256 cellar: :any_skip_relocation, monterey:       "3c9059356699116f9ef7673744a88ec0361fa18a55c6be771743353cd87b8b01"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9e56dd9ccfc504affed64860b3e5d821dcef3d4592a56258843d8baeecb3c4a"
    sha256 cellar: :any_skip_relocation, catalina:       "cf1e24ac162b3021036fc4a3216dc5c4f0cb70397f2588037f8f87f2e7ffd02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d74a6aca65d50a15f614c772d94de0c64f805ac080ad6929e72174c39e8e691a"
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

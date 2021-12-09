class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/2.4.0.tar.gz"
  sha256 "73ec3b7688f9e637f8aca3108a7ae4345a64f82179b6e43d859a3cb6426e78da"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1516d3b41d605a7bdce618ec740e97d69fee4844e450dbbd2383a59ff201df3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c04676862f064979241e4a2c9c1518cb1005a778c645d0ee135c83f610fbf64"
    sha256 cellar: :any_skip_relocation, monterey:       "ff25a0905d1435e414666d2cef65c2497df258a2e8f4f3dcc25f94358e3bdd3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3522812ba3bae93f451bcde49872fa93e7bb6da94d244f357b5fad50d1148341"
    sha256 cellar: :any_skip_relocation, catalina:       "7176c9d6007733071fb7251800ffe7ee335f9808c319a0e1ca053f8ea82b98b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c5449afa5dc6435440c0e4e834d870682aba4b4204808b682707dd474e2dbd1"
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

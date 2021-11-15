class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/2.2.3.tar.gz"
  sha256 "3224e9eadbc13a6eaaef22f5b8ba7bd32723cbac95b8513aa3b7776d8b7955e5"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "354aa4da53d2f8df4154b2cf9d71b444020f2b20bf8af9acc25a995afd875108"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "726e6e93834ae526104c86d97499650e8258a569dc8ab2876497c447fba1e2ba"
    sha256 cellar: :any_skip_relocation, monterey:       "52c2c7d74446cfb5272137d04b9710d8df8804cceda0654d800bf7b978b4bae0"
    sha256 cellar: :any_skip_relocation, big_sur:        "50a65a662b9fa349254f2fa6b093fe8d94ebb6308538252dcdbdb92c51cb7ce0"
    sha256 cellar: :any_skip_relocation, catalina:       "b5ae0b0c2b01e6e2a846788d329e71d6e27210a7c14d8da465841f755fa13445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33eba7847e1671d9edc0196b227b7b73b07446e297e284e8fb6814353eb0906d"
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

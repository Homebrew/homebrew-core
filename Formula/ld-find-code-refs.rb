class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.9.1.tar.gz"
  sha256 "d742a1ea92f7ab938a84368d5e84877a0529d355db3b4ad3a7cbeaf211d00aff"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bb155e9bf555ff9dc06c2cc56594c8fb3bd779cb50e58116dc8713cb4e10e3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab045af40ba2a37383b715e55f0852605971c9795404d4ebfdb65527a720eb5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45f802d18190d6263e94d6b3a6843c3fc7d9a973cb29190e262041c01bb88b24"
    sha256 cellar: :any_skip_relocation, ventura:        "becd0dc8f49e91c465627537f97bd12dc89859e0e915ec30bf66600b1faa1e6c"
    sha256 cellar: :any_skip_relocation, monterey:       "e1832af54d3e7bc6d5ed34fc59a5c32005fe60b40d6869c8f8b270ba43b5bce9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ff84599d1f3b33c9c4bd75f3b76863879c0707a4c9b6c8ff217c1c1e957206b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f714337846b98c04f9793d61060057c7f637e49644dc09058d549f8c5ad2c33"
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

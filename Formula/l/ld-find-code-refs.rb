class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.11.4.tar.gz"
  sha256 "832b3e1253b08030423dd1851a5e77d2fff0c611b5b20cd5917b888cc7a33cae"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20a614982e5bbd384384384b8e2239dd15d5e94ff7c8a3b49b3c062939b9061c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca17c5b93e2052da75fef62e4dee470d4b9240d1493a861e03e3385e0bc116b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25b864e3a2217c292ecda82b2d737e21f3a671702d24fddaf86ef4ae1d3e97a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "68718ca5f9b25daf93f1748e2bda86c144239bce32253fba34c8d5a233f97fee"
    sha256 cellar: :any_skip_relocation, ventura:        "e8b2fef68c2958eaa640c6e07a48c372ede1edac4d8979e9448d8ec71c537520"
    sha256 cellar: :any_skip_relocation, monterey:       "fe2eb29970eef6468eedcf1208cb85acc89742248d8acca5fe924ceedf1e33ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a483753984e1ab00b89e20362b140d2614142bfb89dfe6aab294b89304941ded"
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

class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.10.0.tar.gz"
  sha256 "c4192ecb9a281906425f37bbfd43626d3f3e78b643c9cde28b59a16c1d340258"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d60bab491f188e7b1d2619b9247705b7d9f5839f8afb14f94998b5a55448be0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c95700a2fa1c7b20195ef1fb1cf54428168c2d2ae76181cf009795c4b713a72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29304508204e073961ae05910b6f16412f4b71518104d04b081bc1ae53a5ceb5"
    sha256 cellar: :any_skip_relocation, ventura:        "146305ecec15abb7bd076af886d3c9ba814c0607705afdc4902795066a9943cc"
    sha256 cellar: :any_skip_relocation, monterey:       "5a532953c9213444aa08b2d18b158166576775d90443f2a0dba10418e8125ea2"
    sha256 cellar: :any_skip_relocation, big_sur:        "97ddc08923cd36dd0e8d0dcaaf969c5150ba84580d3d79a671231857f9dad8e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e27d3de56bd72a40494490e228a6768e50d20d015bcc7833a011d584c320ca98"
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

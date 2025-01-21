class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "9367921a6ceb0e00b236f0e6bfc0e7815aa5588c78850abc38015dc9dfaf6091"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a042bbee68be9ce54f73a66ab62347c5188b29da378751c69b36c754800859a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a042bbee68be9ce54f73a66ab62347c5188b29da378751c69b36c754800859a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a042bbee68be9ce54f73a66ab62347c5188b29da378751c69b36c754800859a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e1fbd6b0122cb078632226abecd6ef639b967661556e9014d00c06bfa76b6f2"
    sha256 cellar: :any_skip_relocation, ventura:       "1e1fbd6b0122cb078632226abecd6ef639b967661556e9014d00c06bfa76b6f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8cb73e822ef55794009be3aa1a4cbc1921b634b6abc493c9b2fcd54b31bc274"
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

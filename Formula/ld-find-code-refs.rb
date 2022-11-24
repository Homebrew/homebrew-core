class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.8.0.tar.gz"
  sha256 "4dcb7a817d4bb84827541e059a8dff08c1588a0a5a8980ffabe7b6277b501553"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c09f874d4914dabbeab0e201436b55c3e7c15e6cd7fc7f7d3d19da8f0317cfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f277353c6870b385882ec58d51a5bb964906a662b1c94c7cf2821f74a8f0cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41d91df8660a073ed1f207d860c6219f73fe215a5e376b3b812f9d34cb652fb2"
    sha256 cellar: :any_skip_relocation, monterey:       "78edffdba3d23a8ac68e9be6b88f180c86a15806f7e63fc4eb9596b6bb434d8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf670e862a919e8de4d55c9e85235127d38cb63f463a680bf0fcb27b532fb5db"
    sha256 cellar: :any_skip_relocation, catalina:       "fd4d4837d34694c5d4c14f42d229db9a67f05692f4c5486eb6dc4de8b03fb5fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77398f4f4d4c016686a24a14a7bec5a146307f488cb882217bb922c4b71f1283"
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

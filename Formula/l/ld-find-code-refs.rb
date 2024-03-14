class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.11.10.tar.gz"
  sha256 "66bc925d05b6d7bbd9a5ddd3bc4b62f26d7797ef39d205be63906014bd7aab2d"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1267a670d947d78428ccfb6a310626b8e18ca2e9ad858909fd7fede38c359b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9cceed66f1f27d66f9897a8aed57913aa6f6cadf7151a9f42085a06c4581caa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af4b15e99e9a0fefde43376d0d046b56e96c01c334c20c4a8c1b9ea14be28d13"
    sha256 cellar: :any_skip_relocation, sonoma:         "edb31cfa29850d81774f13387a8de20881b822f7d4ac98bd7ff7a0340f653874"
    sha256 cellar: :any_skip_relocation, ventura:        "e099e7909b85f54340ef9a2363b0f077094ac56d57eefdff59a06e37e5bc3ed3"
    sha256 cellar: :any_skip_relocation, monterey:       "f99b0c9b5db112c8e4a0334f7be9fc8a027b03101af0ed02740e2c27acbb44ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf5a2ec1dc101e36c250bd2874bd7dc19ae43741e46ba58633c574122151c2a4"
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

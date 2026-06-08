class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "c7e305001837e5d7b8c4e1f5dbbaea66e2e4567ff161c0039a5375fd2cf3b791"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cba2b554dc4f9c44c7d609e448a2eba5e58e89d3ddc7d8c565f64c85c7994b27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cba2b554dc4f9c44c7d609e448a2eba5e58e89d3ddc7d8c565f64c85c7994b27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cba2b554dc4f9c44c7d609e448a2eba5e58e89d3ddc7d8c565f64c85c7994b27"
    sha256 cellar: :any_skip_relocation, sonoma:        "36ade1dc502172f4d5bc3674b7fc6fd23605ed565e634590ebac211565df09c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6e7c29473a261d8216897a81054df7677605b5fc2676c74066f2bca86b5d7fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0e9e877e91c100312eb2643ca0ee6b3066afb089678168e2761a86925818aa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ld-find-code-refs"

    generate_completions_from_executable(bin/"ld-find-code-refs", shell_parameter_format: :cobra)
  end

  test do
    system "git", "init"
    (testpath/"README").write "Testing"
    (testpath/".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"

    assert_match "could not retrieve flag key",
      shell_output("#{bin}/ld-find-code-refs --dryRun \
                   --ignoreServiceErrors -t=xx -p=test -r=test -d=. 2>&1", 1)
  end
end

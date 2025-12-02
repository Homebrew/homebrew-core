class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "c7e305001837e5d7b8c4e1f5dbbaea66e2e4567ff161c0039a5375fd2cf3b791"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffe2918d665942cacee1a84ad3003704f05fb7c28bfb2121881d7bd4504ba8a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8fe7f8ffeef61b1ca2160f60d7b5dc13ae55482dff0c7cdf5adcfa0ec547e8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8fe7f8ffeef61b1ca2160f60d7b5dc13ae55482dff0c7cdf5adcfa0ec547e8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8fe7f8ffeef61b1ca2160f60d7b5dc13ae55482dff0c7cdf5adcfa0ec547e8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2445c7dfdaf87d5075d6ed499179629095dc2445ec4eba04a7b18465179c95f"
    sha256 cellar: :any_skip_relocation, ventura:       "f2445c7dfdaf87d5075d6ed499179629095dc2445ec4eba04a7b18465179c95f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cebea5aeed380bd655c9d2e8af2fd14c2fbf33ab64228ba9256694be50d88218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a33733870e77a06fbd6e96076ea78ac84a30c2549a3f6fb6694705911abe1e65"
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
      shell_output("#{bin}/ld-find-code-refs --dryRun \
                   --ignoreServiceErrors -t=xx -p=test -r=test -d=. 2>&1", 1)
  end
end

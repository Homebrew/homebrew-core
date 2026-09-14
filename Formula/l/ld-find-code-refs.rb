class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://launchdarkly.com"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "07f8a1898ee848750cc22eed4fffea0624e0f124288097dcd6c19e8cdeed1187"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f09cd32487e76e355a6aaec3ec3c94d30fd584d9a2b5040d8f387cd29abc8887"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f09cd32487e76e355a6aaec3ec3c94d30fd584d9a2b5040d8f387cd29abc8887"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f09cd32487e76e355a6aaec3ec3c94d30fd584d9a2b5040d8f387cd29abc8887"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eb51888b7f98a86b086f13c1aa308642b9250a388cb24d8e617e87ae63363250"
    sha256 cellar: :any,                 x86_64_linux:      "6f33ac0bc1fae1e8566ac7308e2bd01a163b6175875cb6d8a2fa1eb97f995ad1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/ld-find-code-refs"

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

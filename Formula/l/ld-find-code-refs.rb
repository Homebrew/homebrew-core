class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://launchdarkly.com"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.18.3.tar.gz"
  sha256 "92096763f2a9950b20b3798ed4e2b8613ac77981db18b5e078c505ea341f73af"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fcf697eb5ce18951905e01c903d081cab92a2460cdc91c9958d3c389370838a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fcf697eb5ce18951905e01c903d081cab92a2460cdc91c9958d3c389370838a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fcf697eb5ce18951905e01c903d081cab92a2460cdc91c9958d3c389370838a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a17d8472baeb69ea44b3ec5d1240a5b61194c8d19f3c5ac3f7bb795bc177510d"
    sha256 cellar: :any,                 x86_64_linux:      "950f7c2f33be27f3576e266d407d1e0bd30872b6c054a8dbcf2681d7425605c2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

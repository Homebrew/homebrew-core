class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://launchdarkly.com"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.18.4.tar.gz"
  sha256 "0f0da15bd8785de0a75a5876660ddcd12ac21deba176bd40760d65cb2e01af94"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26acdf803b336880349694719afa1f246b1c8888397bc8a92ebe526b8471e10e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26acdf803b336880349694719afa1f246b1c8888397bc8a92ebe526b8471e10e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26acdf803b336880349694719afa1f246b1c8888397bc8a92ebe526b8471e10e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "94bae9a74944ae56c21f1ff7c4cbed864a9a75382208dc982110d129a0d8389d"
    sha256 cellar: :any,                 x86_64_linux:      "e961cfc1592c7b85707d734df0a5c1bdf290bc47bb855a41e0a7de9b0bdb8259"
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

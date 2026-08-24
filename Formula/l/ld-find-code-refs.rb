class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://launchdarkly.com"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "27b30c4900c8b56d9646e875fbc7ce80e848f0eb4d48fcaddfcde8a3b8c37b9d"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "153c354766a0fd86f382848ecfd3a3b79a6fb2dbbc796f5b5e87fe7ebbcb1738"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "153c354766a0fd86f382848ecfd3a3b79a6fb2dbbc796f5b5e87fe7ebbcb1738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "153c354766a0fd86f382848ecfd3a3b79a6fb2dbbc796f5b5e87fe7ebbcb1738"
    sha256 cellar: :any_skip_relocation, sonoma:        "39237943638a5a43521d28dd74aa2a70d70aa8cbfbe25b933d6702ddb5fcc1fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1ca77d19e09b06b6372593076295e56778070d9178b9ec2727664673eae872a"
    sha256 cellar: :any,                 x86_64_linux:  "a242da99dbf4be66986e481dec806ea2d678ca7571ed8558001de23a8c379be8"
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

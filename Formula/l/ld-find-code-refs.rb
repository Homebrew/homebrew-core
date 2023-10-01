class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.11.3.tar.gz"
  sha256 "e53f8720d2ecb71bfa1727c05bbb6e9df11911d9af9476c561d4ef0d121e6c34"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e1b80221da9d786ba9b27e418d42e3985c6152d3815debdcc8da73dfadab7b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31e09bfecf5578ba5baf52c673d2d8c22e4704593912b9781a9d6e93a5962e8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf255404a77fe47b784cf41418d13c202f1f37074d72d4f80eeff816447d0665"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c40116d922c5ae48231f0bf6aa39529854d4276605d316380397d6b630c269bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ce274614ec9dc7ff2098425ddd5498602955106d7e16481d581b96674565aee"
    sha256 cellar: :any_skip_relocation, ventura:        "84dc469e8fd0dc71178d27b547418a8d9163e2a5075c249fff3e43817c5b26ef"
    sha256 cellar: :any_skip_relocation, monterey:       "100d5327bd28f30037a8974ddd6535582b4f98da410428665d19e739f256e52b"
    sha256 cellar: :any_skip_relocation, big_sur:        "51ae88723751da856bb1704a40815b3e25e07440c351b0885240723045fcfa0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "446cbad70ccdd0f313083b81022ee553848f39b795ec194ed267069a6327c614"
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

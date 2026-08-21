class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.56.0.tgz"
  sha256 "dfacdc725c02fb84071c90e6c9a8bbd1d40aba480fe89734968e9caa283a72bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75b7e2fbcf9b5ee649d652c5723e54ee839b9d503a3f83ff0e1d44a3c9a07bee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75b7e2fbcf9b5ee649d652c5723e54ee839b9d503a3f83ff0e1d44a3c9a07bee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75b7e2fbcf9b5ee649d652c5723e54ee839b9d503a3f83ff0e1d44a3c9a07bee"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3a76e3fe31d39ce5c36e28805982b86e98c69a3e6f13b3e07b8ae029e4a1be9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7cd0caa792e1eea111a6f0711f94a1124ab792a9cd750e36a1fee6267702081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33e95ae2db67aa1e6dbc755747270ea9b879f98f6ba688a52daabc3feddc4f73"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    resource "testdata" do
      url "https://raw.githubusercontent.com/finos/architecture-as-code/717350bec736a7f931c7c09df6b0b0b56e51612f/calm/getting-started/conference-signup.pattern.json"
      sha256 "26bb2979bb3e8a3a8eea2dfe0bd19aaa374770be61ee42c509c773c2fcc6c063"
    end

    testpath.install resource("testdata")
    system bin/"calm", "generate",
                       "--pattern", "./conference-signup.pattern.json",
                       "--output", "./conference-signup.arch.json"
    assert_match "conference-website", (testpath/"conference-signup.arch.json").read
    # TODO: restore `--architecture` roundtrip once upstream `generate` emits the `control-id` required since 1.50.0
    system bin/"calm", "validate",
                       "--pattern", "./conference-signup.pattern.json",
                       # "--architecture", "./conference-signup.arch.json",
                       "--output", "./conference-signup.validate.json"

    assert_match version.to_s, shell_output("#{bin}/calm --version")
  end
end

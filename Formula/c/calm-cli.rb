class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.74.1.tgz"
  sha256 "1beb77206362d23339dea9de44b201e689cbdfe3fd76f6f1fea7ac868fdf268a"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "51f8bb8eb4048199126e11278daf1cd3f41572326e14c4c7d661e0736e209111"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0cdbffbd9199389cedad70f4663f253e612bc8b222f48f500526f5bd744a4b15"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cdbffbd9199389cedad70f4663f253e612bc8b222f48f500526f5bd744a4b15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0cdbffbd9199389cedad70f4663f253e612bc8b222f48f500526f5bd744a4b15"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "69427464a6ec5ae0ed4b36a1f2617af315ca53ccc9512f182ad536bf53714666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "745e0f4d2eda5ad70f9c24187eff825b07f32c43011df104edb28b36b9cd1f3b"
  end

  depends_on "node"

  resource "testdata", :test do
    url "https://raw.githubusercontent.com/finos/architecture-as-code/717350bec736a7f931c7c09df6b0b0b56e51612f/calm/getting-started/conference-signup.pattern.json"
    sha256 "26bb2979bb3e8a3a8eea2dfe0bd19aaa374770be61ee42c509c773c2fcc6c063"
  end

  allow_network_access! [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
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

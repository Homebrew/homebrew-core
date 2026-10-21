class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.64.0.tgz"
  sha256 "a7d55162266a334e1c8fd4152afdeaa53e5de83265c01a927a8b9d495565dcf3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea1e448ee02134cf6077f0e2c6bf3f1ca1945aa6c9c63707d19fe18d02e90474"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea1e448ee02134cf6077f0e2c6bf3f1ca1945aa6c9c63707d19fe18d02e90474"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea1e448ee02134cf6077f0e2c6bf3f1ca1945aa6c9c63707d19fe18d02e90474"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0d08e9e1d6217ebb1e640bb4f236c73d52863d7182673f4cb0aba7e500dd878e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3f5d39c737c7f8fdfb10c395dca6dd3eb2c0d6c56d8d28ccf256b84337f2fc15"
  end

  depends_on "node"

  resource "testdata", :test do
    url "https://raw.githubusercontent.com/finos/architecture-as-code/717350bec736a7f931c7c09df6b0b0b56e51612f/calm/getting-started/conference-signup.pattern.json"
    sha256 "26bb2979bb3e8a3a8eea2dfe0bd19aaa374770be61ee42c509c773c2fcc6c063"
  end

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

class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.73.0.tgz"
  sha256 "23a9ca90b395b5311052e6a40e4ff078f29bbb8b294a80d539a9f79b29f81326"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4bc2f1374f5b0d9ef349e6c86bbbf0b63956c7dec7e08ce589eb16bb8ec24b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4bc2f1374f5b0d9ef349e6c86bbbf0b63956c7dec7e08ce589eb16bb8ec24b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4bc2f1374f5b0d9ef349e6c86bbbf0b63956c7dec7e08ce589eb16bb8ec24b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bebe8ff19144d169d2c1bc94802371acc5371164f2ce4803ff202455908d8e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "acc98cb408509ea6968870b04b7608c130b52a97336134dbaa4aea7ebf648acc"
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

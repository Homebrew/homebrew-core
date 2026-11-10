class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.69.0.tgz"
  sha256 "be53fbc2e33ab8a4268595b8c8b82f8c0684ff71a79c70046dd6dd8323a26f15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3773f8c7a23c34036edbcb5c0f9c02a38133b19dab5cb33c9cebf9f1a46a48e1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3773f8c7a23c34036edbcb5c0f9c02a38133b19dab5cb33c9cebf9f1a46a48e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3773f8c7a23c34036edbcb5c0f9c02a38133b19dab5cb33c9cebf9f1a46a48e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5f0f0ef89e8f9bcfb38c98c9c8c4ed034142f942aa70b481480c232cda1f51c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5de5f9d8e322a8df31d972eaaeff157420e65639cf91e1600c98adb200f60d8d"
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

class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.74.2.tgz"
  sha256 "eae9b0162f0daab4d64651aab3fc9af80559d347fa693c7d33ac25ef4dc6d963"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "dcf0facdec344ac436d4a2da0eb3b5720cf6d6062165d657c6566c031036b0f5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1501235fea78b0e24ae13232a825a17389b15985455c94f2f3e15bf55d8bca67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1501235fea78b0e24ae13232a825a17389b15985455c94f2f3e15bf55d8bca67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1501235fea78b0e24ae13232a825a17389b15985455c94f2f3e15bf55d8bca67"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1b045c5520e222274d80c7e8ff42edd9e46a5840eb018f26276616d2395936c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3fd15f59f8e7ada0b1a2a295a70356076100af8cb40b334d0ebc2cae6c775f80"
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

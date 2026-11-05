class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.68.0.tgz"
  sha256 "47231a722e02c75d098ddd48776da8cc5de8a18c620f5bfaf436f8446a6f9f4b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4539da29cdf1262e58b25cac31d25432fd32f0bf583efefd2ed8322039552ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4539da29cdf1262e58b25cac31d25432fd32f0bf583efefd2ed8322039552ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b4539da29cdf1262e58b25cac31d25432fd32f0bf583efefd2ed8322039552ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e96e4d5f9aab313a8a53a7f23610f3061ab4c20d90d4a927ee2ec7a4723cb29d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ba919870dfe388cbee61d9aa72fa9a2c27dba342fb778a2718ae12c31f9a9176"
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

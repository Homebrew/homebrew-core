class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.74.0.tgz"
  sha256 "e2f68b6de690858b72ce7500b276af79193ac2006de506727580028713735b5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2ce087a476a99c07f9eeb44f6875d61aaab4f2ec4dd7ca1913ffa13796d9d1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2ce087a476a99c07f9eeb44f6875d61aaab4f2ec4dd7ca1913ffa13796d9d1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d2ce087a476a99c07f9eeb44f6875d61aaab4f2ec4dd7ca1913ffa13796d9d1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eccfc01508b085a54b3214c458203c41e97e95f2964cfa92a47dfa46db0a9427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4a3ec71de23cffdd7f3f5bcb97bede5e507304e65bb1227d1a8e01ac29ab1207"
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

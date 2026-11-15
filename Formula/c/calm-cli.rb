class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.72.0.tgz"
  sha256 "104bbfdca7386749c96a71a9d3e0f500e307db469577630084b481e354b63a93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6559b85312ec6b0eb80085286814bca68abaebd3e6301cdd80b02a3ae52b1079"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6559b85312ec6b0eb80085286814bca68abaebd3e6301cdd80b02a3ae52b1079"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6559b85312ec6b0eb80085286814bca68abaebd3e6301cdd80b02a3ae52b1079"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6db85a862c40374412ff1ad1a60a45b5f4e52bc6ba7c59add34420caa203fe13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6ae93cccaf46afd0c5959b62536abe2e6a95d93f3d20d216532d3838cd188879"
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

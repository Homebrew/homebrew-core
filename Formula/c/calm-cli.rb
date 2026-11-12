class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.70.0.tgz"
  sha256 "44a6eaa6b1164b548d988dc9152378ecbea4e86e65da60d2ed281ad5f4efe283"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51486cb2a7e9e139ddb23fe770e5a3ccee16791e5d42fd0d11ca6e88b742a427"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "51486cb2a7e9e139ddb23fe770e5a3ccee16791e5d42fd0d11ca6e88b742a427"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "51486cb2a7e9e139ddb23fe770e5a3ccee16791e5d42fd0d11ca6e88b742a427"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb332bfa4e6bb976b9496344cfd30430509d1dcc0d8f346e5a411544086f0d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1e33b3e10f3a0d22711e4209c6afd3b2bdefc65a76edbb5b8c170868118d14a7"
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

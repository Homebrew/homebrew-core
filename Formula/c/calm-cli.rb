class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.49.0.tgz"
  sha256 "bdf2072cbd36861807e67bca0e6383de34806474990a6f1564a255db2879dc7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "505c761d2effa5bf223abed200ec06927281886620f5a5257065e86203745c1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "505c761d2effa5bf223abed200ec06927281886620f5a5257065e86203745c1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "505c761d2effa5bf223abed200ec06927281886620f5a5257065e86203745c1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "766120a9d4603cc3e8cb268a04b539e26d5c70434f7a5acb31654138b2cb4e6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f94e9f73a8deedf818f28b0f729e303e39c403d305d21d8166c85c818b4ac5f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "137ffeae718d27a2e91e8615586e05cd169590bbb5036f8a43c8df23fbc9a56d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    resource "testdata" do
      url "https://raw.githubusercontent.com/finos/architecture-as-code/refs/heads/main/calm/getting-started/conference-signup.pattern.json"
      sha256 "26bb2979bb3e8a3a8eea2dfe0bd19aaa374770be61ee42c509c773c2fcc6c063"
    end

    testpath.install resource("testdata")
    system bin/"calm", "generate",
                       "--pattern", "./conference-signup.pattern.json",
                       "--output", "./conference-signup.arch.json"
    system bin/"calm", "validate",
                       "--pattern", "./conference-signup.pattern.json",
                       "--architecture", "./conference-signup.arch.json",
                       "--output", "./conference-signup.validate.json"

    assert_match version.to_s, shell_output("#{bin}/calm --version")
  end
end

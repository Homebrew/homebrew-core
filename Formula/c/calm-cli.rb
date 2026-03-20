class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.34.4.tgz"
  sha256 "649b008f9a10912e3d960a64944c644feb7253b31635c655706b1ac64695f801"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "459b0117133b9e8e3209af70e409e03f5781701521bfe9ea5622738380642d05"
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

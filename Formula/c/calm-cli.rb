class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.72.0.tgz"
  sha256 "104bbfdca7386749c96a71a9d3e0f500e307db469577630084b481e354b63a93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed8421767719045b7cd3bca381b88f0fac81445151e5a564c252763a7bc47d7e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed8421767719045b7cd3bca381b88f0fac81445151e5a564c252763a7bc47d7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed8421767719045b7cd3bca381b88f0fac81445151e5a564c252763a7bc47d7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f2298a81cf86ac50f37388fc4d4e890628ab7118d844a3a42a28303713e42564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2c93fb70c268df20a0a43fcf7b56fb0aa3e1884eff217939801973a1f536ea12"
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

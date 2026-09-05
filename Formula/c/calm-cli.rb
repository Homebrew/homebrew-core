class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.58.0.tgz"
  sha256 "3d7df535e55aada02f9787cfa68a493dd73a0cc4c6b29263c63e44a74e381eb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6293ff2954c1d02aa64793d73f2b36316148d34befd010800f40be7350680df8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6293ff2954c1d02aa64793d73f2b36316148d34befd010800f40be7350680df8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6293ff2954c1d02aa64793d73f2b36316148d34befd010800f40be7350680df8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cee900a7a1a5f6bc5f547f3e7a26808a6dc373e765101a5553f140c6ba8175ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da77c8656a05624ca1122a39ce739d3f2974ae3fd795d6b030edfc2b623a211"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    resource "testdata" do
      url "https://raw.githubusercontent.com/finos/architecture-as-code/717350bec736a7f931c7c09df6b0b0b56e51612f/calm/getting-started/conference-signup.pattern.json"
      sha256 "26bb2979bb3e8a3a8eea2dfe0bd19aaa374770be61ee42c509c773c2fcc6c063"
    end

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

require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.16.0.tgz"
  sha256 "01f2eaf5cee02db2cf6494a70c46d7063c41db34797475ff3ceb98e024c36ff8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac28bbdf4ca9fbe93d8108035ba025b5afa2ef10f320844dda11bc848b576d70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac28bbdf4ca9fbe93d8108035ba025b5afa2ef10f320844dda11bc848b576d70"
    sha256 cellar: :any_skip_relocation, monterey:       "0ff8152dafca1cb7add4c32fa3f987b27c59e9c7ff9a8b6b536e03fb5bf7a7db"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ff8152dafca1cb7add4c32fa3f987b27c59e9c7ff9a8b6b536e03fb5bf7a7db"
    sha256 cellar: :any_skip_relocation, catalina:       "0ff8152dafca1cb7add4c32fa3f987b27c59e9c7ff9a8b6b536e03fb5bf7a7db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65eeb93adb3836e037bfb46f7ddec96be63fe0e7ed2b3adecf3fc748140aa7b4"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end

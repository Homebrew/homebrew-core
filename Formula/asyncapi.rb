require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.13.1.tgz"
  sha256 "b02219e0cdc6ec3a53c6f6d771efc15ef0c3ba5c2d7ee684d15b997ea8ba10e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e1486d2ccda8986de897a61ae8a24610519b180525a4de1324da50a1e90bc90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e1486d2ccda8986de897a61ae8a24610519b180525a4de1324da50a1e90bc90"
    sha256 cellar: :any_skip_relocation, monterey:       "d2fbb53780ad02276d05ca8784f743c617b42013cec84cab2ed63dd6e8cd5d19"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2fbb53780ad02276d05ca8784f743c617b42013cec84cab2ed63dd6e8cd5d19"
    sha256 cellar: :any_skip_relocation, catalina:       "d2fbb53780ad02276d05ca8784f743c617b42013cec84cab2ed63dd6e8cd5d19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10cebb141ff9e73219650a5c97a52e8b18a1797dba0838af9220907fa4cfac0a"
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
